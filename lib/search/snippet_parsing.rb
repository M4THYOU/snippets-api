module SnippetParsing
  class << self
    ##
    # Converts the raw value of a snippet from DB into a string, exactly as it was entered.
    # raw: hash with a key called 'raw_snippet'
    # @return string
    def raw_to_raw_string(raw)
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
    # Remove all 'dirty' values from a string.
    # str: string
    # Replace with backslash instead of space because splitting by ' ' later on
    # will eliminate them anyway.
    def clean_search_string(str)
      str = str.tr('\\', ' ') # replace backslashes with spaces
      str = str.tr('.', ' ') # replace periods with spaces
      str = str.tr(',', ' ') # replace commas with spaces
      str.downcase # lowercase it
    end

    ##
    # Converts the raw value of a snippet from DB into a string.
    # raw: hash with a key called key.
    # key: string, a key in the raw hash.
    # @return string
    def raw_to_search_string(raw, key)
      s = ''
      raw = JSON.parse raw
      text = raw[key]
      text.each do |part|
        s << part['value']
      end
      clean_search_string s
    end
  end
end