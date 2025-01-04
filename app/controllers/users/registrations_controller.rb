class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
    skip_before_action :authenticate_user!, only: [:create]
    
    # def create
      
    #   build_resource(sign_up_params)
      
    #   if resource.save
    #     UserMailer.confirmation_email(sign_up_params).deliver_now
    #     render json: { message: 'Signed up successfully.' }, status: :ok
    #   else
    #     render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    #   end
    # end
  

  def create
    @user = User.new(sign_up_params)
    if @user.save
      UserMailer.confirmation_email(@user).deliver_now
      require 'rotp'
      secret = ROTP::Base32.random_base32
      @user.update(otp_secrect: secret)
      render json: { message: 'Confirmation email sent. Please check your inbox.' }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
    private

    def sign_up_params
      params.require(:registration).permit(:email, :password, :password_confirmation)
    end

  end
  



  