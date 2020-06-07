require 'json'

module Search
  include SnippetParsing
  class << self

    def get_s(raw)
      query = {
        'query': JSON.parse(raw)
      }.to_json
      SnippetParsing.raw_to_search_string query, 'query'
    end

    def query_word(word, current_h)
      word_index = SearchIndex.where(['word = ?', word])
      word_index.each do |item|
        key = item.snippet_id
        if current_h.key? key
          current_h[key] += item.weight
        else
          current_h[key] = item.weight
        end
      end
      current_h
    end

    def sort_snippets(snippets, search_h)
      h = {}
      a = []
      snippets.each do |snippet|
        h[snippet] = search_h[snippet.id] # {Snippet => weight}
      end
      h.sort_by { |_key, val| val }.reverse # stored as [[Snippet, weight] ...]
      h.each do |item|
        a << item[0] # convert it to array of just snippets
      end
      a
    end

    def search(raw)
      search_s = get_s raw
      s_words = search_s.split(' ')
      h = {}
      s_words.each do |word|
        next if word.length == 1 # ignore single character words

        h = query_word word, h
      end

      snippets = Snippet.where(id: h.keys)
      sort_snippets snippets, h
    end
  end
end
