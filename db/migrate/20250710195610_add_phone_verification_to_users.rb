class AddPhoneVerificationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :phone_verified, :boolean
    add_column :users, :verification_code, :string
    add_column :users, :verification_sent_at, :datetime
  end
end
