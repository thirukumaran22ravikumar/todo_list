# app/lib/json_web_token.rb
class JsonWebToken
    SECRET_KEY = Rails.application.credentials.jwt_secret_key
  
    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      decoded[0].symbolize_keys
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    end
  end
  