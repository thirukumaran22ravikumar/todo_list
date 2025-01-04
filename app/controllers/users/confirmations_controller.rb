class Users::ConfirmationsController < ApplicationController
    skip_before_action :authenticate_user!
    def confirm
        user = User.find_by(email: params[:email])
        if user 
            if user.confirmation_token == params[:confirmation_token]
                user.update(confirmation_token: nil, confirmed_at: Time.now)
                render json: { message: 'Account confirmed successfully.' }, status: :ok
            else
                render json: { errors: ['Invalid confirmation token'] }, status: :unprocessable_entity
            end
        end
      
    end

    def verify_otp
        user = User.find_by(email: params[:email])
        if user 
            totp = ROTP::TOTP.new(user.otp_secrect)

            if totp.verify(params[:otp],drift_behind: 30,drift_ahead: 30)
                puts "OTP is valid!"
                render json: { token: user.generate_jwt, message: 'Logged in successfully' }, status: :ok
            else
                puts "Invalid OTP!"
                render json: { message: "Invalid OTP!- #{totp.now}" }, status: :ok
            end
        end


    end

  end
  