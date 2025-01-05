# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]
  respond_to :json
  require 'rotp'
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  puts "----"
  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        decoded_token = JsonWebToken.decode(token)
        jti = decoded_token[:jti] # Assuming the JWT has a unique identifier (jti)

        # Optional: Implement token blacklisting logic if needed
        # Redis.current.set("blacklist_#{jti}", true, ex: 24.hours)

        render json: { message: 'Logged out successfully' }, status: :ok
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Authorization token missing' }, status: :unauthorized
    end
  end




  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  

  def create
    
    user = User.find_for_database_authentication(email: params[:email])
    if user && user.confirmation_token.present?
      render json: { error: 'Please Verify the Account' }, status: :unauthorized
    else
      if user && user.valid_password?(params[:password])
        UserMailer.otp_email(user).deliver_now
        render json: { message: 'OTP has been sent to your registered email. It is valid for only 30 seconds.' }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end 
    end
  end
  
end
