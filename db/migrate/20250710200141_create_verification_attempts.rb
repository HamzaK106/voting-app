class CreateVerificationAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :verification_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone
      t.string :code
      t.boolean :success
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
  end
end
