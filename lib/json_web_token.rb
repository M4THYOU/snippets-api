class JsonWebToken
  class << self

    def encode(payload, exp = 4.hours.from_now)
      payload[:exp] = exp.to_i
      secret = Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
      puts secret
      puts secret.nil?
      secret2 = Rails.application.credentials.dig(:secret_key_base)
      puts secret2
      puts secret2.nil?
      JWT.encode(payload, secret)
    end

    def decode(token)
      secret = Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base
      body = JWT.decode(token, secret)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end

  end
end
