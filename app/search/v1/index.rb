# Search Rules
# Ignore backslashes.
# Ignore backticks.
# Title words have 25 weight.
# Snippet words have 10 weight.
# Note words have 5 weight.
# lowercase it.
#
# @todo
# Ignore words that are just 1 character.
# Ignore some punctuation, like commas and periods. Keep curly braces though.

module Indexing
  # Module Constants
  TITLE_WEIGHT = 25
  SNIPPET_TEXT_WEIGHT = 10
  NOTE_TEXT_WEIGHT = 5

  ##
  # Converts the raw value of a snippet from DB into a string, exactly as it was entered.
  # raw: hash with a key called 'raw_snippet'
  # @return string
  def self.raw_to_raw_string(raw)
    s = ''
    raw = JSON.parse raw
    text = raw['raw_snippet']
    text.each do |part|
      value = part['value']
      if part['isMath']
        new_s = '`' + value + '`'
        s << new_s
      else
        s << value
      end
    end
    s
  end

  ##
  # Converts the raw value of a snippet from DB into a string.
  # effects: removes '\\' and converts to lowercase.
  # raw: hash with a key called key.
  # key: string, a key in the raw hash.
  # @return string
  def self.raw_to_search_string(raw, key)
    s = ''
    raw = JSON.parse raw
    text = raw[key]
    text.each do |part|
      s << part['value']
    end
    s.tr('\\', '').downcase
  end

  ##
  # Converts a string into a hash of the given weights per word.
  # effects: Ignore 1 character words and adds weights for duplicate words
  # s: String
  # weight_per_word: Integer
  # used: Hash (an existing word hash)
  # @return hash
  def self.string_to_word_hash(str, weight_per_word, used)
    s_words = str.split(' ')
    s_words.each do |word|
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
  def self.weight_snippet(title, search_string, used)
    used = string_to_word_hash title, TITLE_WEIGHT, used
    string_to_word_hash search_string, SNIPPET_TEXT_WEIGHT, used
  end

  ##
  # Create a hash with all word weights from a given note
  # text: string
  # used: Hash (an existing word hash)
  # @return hash
  def self.weight_note(text, used)
    string_to_word_hash text, NOTE_TEXT_WEIGHT, used
  end

  def self.main
    snippets = Snippet.order('updated_at DESC')

    snippets.each do |snippet|
      search = raw_to_search_string snippet.raw, 'raw_snippet'
      used = weight_snippet snippet.title.downcase, search, {}
      puts used
      puts "\n"

      notes = Note.where(['snippet_id = ?', snippet.id])
      notes.each do |note|
        search_note = raw_to_search_string note.text, 'raw'
        used = weight_note search_note, used
      end
      puts used

      puts "\n\n\n"
    end
  end

end

Indexing.main
