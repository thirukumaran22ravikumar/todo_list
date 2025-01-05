class ApplicationController < ActionController::API

    before_action :authenticate_user!

    private
  
    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last
      
      decoded_token = JsonWebToken.decode(token)
      p decoded_token
      p "000000000000"
      @current_user = User.find_by(id: decoded_token["user_id"]) if decoded_token
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  

end
