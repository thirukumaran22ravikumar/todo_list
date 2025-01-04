# app/models/json_web_token.rb
require 'jwt'
class JsonWebToken
    SECRET_KEY = Rails.application.credentials.secret_key_base.to_s
  
    def self.encode(payload, exp = 24.hours.from_now)
      p SECRET_KEY
      p "secret key"
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      p token
      p SECRET_KEY
      p "---decode----------------"
      pp = token.gsub('Bearer<', '').gsub('>', '')
      puts pp

      body = JWT.decode(pp, SECRET_KEY)
      puts "body--"
      puts body[0]
      data = HashWithIndifferentAccess.new(body)
      return body[0]
    
    end
end


  