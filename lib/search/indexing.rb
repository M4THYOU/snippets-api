# Search Rules
# Ignore backslashes.
# Ignore backticks.
# Title words have 25 weight.
# Snippet words have 10 weight.
# Note words have 5 weight.
# lowercase it.
# Ignore words that are just 1 character.
# Ignore some punctuation, like commas and periods. Keep curly braces though.

module Indexing
  include SnippetParsing

  class << self
    # Module Constants
    TITLE_WEIGHT ||= 25
    SNIPPET_TEXT_WEIGHT ||= 10
    NOTE_TEXT_WEIGHT ||= 5

    ##
    # Converts a string into a hash of the given weights per word.
    # effects: Ignore 1 character words and adds weights for duplicate words
    # s: String
    # weight_per_word: Integer
    # used: Hash (an existing word hash)
    # @return hash
    def string_to_word_hash(str, weight_per_word, used)
      s_words = str.split(' ')
      s_words.each do |word|
        next if word.length == 1 # ignore single character words

        if used[word]
          used[word] += weight_per_word
        else
          used[word] = weight_per_word
        end
      end
      used
    end

    ##
    # Create a hash with all word weights from a given snippet
    # title: string
    # search_string: string
    # used: Hash (an existing word hash)
    # @return hash
    def weight_snippet(title, search_string, used)
      used = string_to_word_hash title, TITLE_WEIGHT, used
      string_to_word_hash search_string, SNIPPET_TEXT_WEIGHT, used
    end

    ##
    # Create a hash with all word weights from a given note
    # text: string
    # used: Hash (an existing word hash)
    # @return hash
    def weight_note(text, used)
      string_to_word_hash text, NOTE_TEXT_WEIGHT, used
    end

    def note_search_hash(note, used)
      search_note = SnippetParsing.raw_to_search_string note.text, 'raw'
      weight_note search_note, used
    end

    def snippet_search_hash(snippet)
      search = SnippetParsing.raw_to_search_string snippet.raw, 'raw_snippet'
      used = weight_snippet snippet.title.downcase, search, {}

      notes = Note.where(['snippet_id = ?', snippet.id])
      notes.each do |note|
        note_search_hash note, used
      end

      used
    end

    def index_search_hash(search, snippet_id)
      search.each do |word, weight|
        idx = {
            word: word,
            snippet_id: snippet_id,
            weight: weight
        }
        SearchIndex.upsert(idx)
      end
    end

    def index_single(snippet)
      search_hash = snippet_search_hash snippet
      index_search_hash search_hash, snippet.id
    end

    def de_index_single(snippet)
      SearchIndex.delete_by(snippet_id: snippet.id)
    end

    def reindex_single(snippet)
      de_index_single snippet
      index_single(snippet)
    end

    def main
      snippets = Snippet.order('updated_at DESC')

      snippets.each do |snippet|
        index_single snippet
      end
    end
  end

end

Indexing.main
