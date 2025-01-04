class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  before_create :generate_confirmation_token
  # after_create :send_email_user

  def generate_jwt
    JsonWebToken.encode(user_id: id)
  end

  has_many :workspace_memberships, dependent: :destroy
  has_many :workspaces, through: :workspace_memberships

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(10)
  end

  def confirm!
    update(confirmed_at: Time.current, confirmation_token: nil)
  end
  # Override confirmation instructions to suppress email sending
  def send_confirmation_instructions
    # Do nothing or implement your custom logic
  end

  # def send_email_user
  #   MailingService.send_mail("ramcharanfz014@gmail.com")
  # end
end


