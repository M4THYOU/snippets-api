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

    def search(raw)
      search_s = get_s raw
      s_words = search_s.split(' ')
      s_words.each do |word|
        next if word.length == 1 # ignore single character words

        puts word
      end
    end
  end
end
