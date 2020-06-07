class RenderJson
  class << self

    def success(message, data)
      {
        status: 'SUCCESS',
        message: message,
        data: data
      }
    end

    def error(message, data)
      {
        status: 'ERROR',
        message: message,
        data: data
      }
    end

  end
end
