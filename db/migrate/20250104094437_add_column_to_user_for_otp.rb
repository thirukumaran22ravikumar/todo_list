class AddColumnToUserForOtp < ActiveRecord::Migration[7.1]
  def change
    add_column  :users, :otp_secrect, :string
  end
end
