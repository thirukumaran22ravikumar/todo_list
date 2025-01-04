# class MailingService
#   require 'mailgun-ruby'
#   def self.run_mail
#       # First, instantiate the Mailgun Client with your API key
#       mg_client = Mailgun::Client.new '7bffa8388d43836e0089570278b83526-e61ae8dd-0262fe83'
#       # Define your message parameters
#       message_params =  { from: 'thiru@saastrail.com',
#                           to:   'kumaranthiru80@gmail.com',
#                           subject: 'The Ruby SDK is awesome!',
#                           text:    'It is really easy to send a message!'
#                       }

#       # Send your message through the client
#       mg_client.send_message 'thiru@saastrail.com', message_params
#   end
# end



class MailingService
  require 'mailgun-ruby'
  

  # def self.run_mail
  #   # api_key = Rails.application.credentials.mailgun[:api_key]
  #   # domain = Rails.application.credentials.mailgun[:domain]

  #   # puts "API Key: #{api_key}"
  #   # puts "Domain: #{domain}"

  #   mg_client = Mailgun::Client.new('7bffa8388d43836e0089570278b83526-e61ae8dd-0262fe83')

  #   message_params = {
  #     from: 'mailgun@sandbox46ef5c93ec42458a88c01714d46a1520.mailgun.org',
  #     to: 'bar@example.com',
  #     subject: 'Test Email from Localhost',
  #     text: 'This is a test email sent from a local Rails app using Mailgun.'
  #   }

  #   mg_client.send_message("sandbox46ef5c93ec42458a88c01714d46a1520.mailgun.org", message_params)
  # end
  def self.send_mail(emails)
		UserMailer.send_simple_email(emails).deliver_now
		puts "----"
	end

  def self.generate_otp
    require 'rotp'
    secret = ROTP::Base32.random_base32
    puts "Your secret key: #{secret}"
    # Generate TOTP using the secret
    totp = ROTP::TOTP.new(secret)
    otp = totp.now # Generate the current OTP
    puts "Your OTP is: #{otp}"
  end

  def self.gg(data,secret)
    require 'rotp'
    totp = ROTP::TOTP.new(secret)
    otp = totp.now

    puts "Generated OTP: #{otp}"
    if totp.verify(data)
      puts "OTP is valid!"
    else
      puts "Invalid OTP!"
    end

  end
end
