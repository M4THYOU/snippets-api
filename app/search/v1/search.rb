require_relative 'snippet_parsing'

module Searching
  def self.search(raw)
    puts raw_to_search_string raw, 'raw_search'
  end
end
