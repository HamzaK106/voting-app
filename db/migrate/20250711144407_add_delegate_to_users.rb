class AddDelegateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :delegate, foreign_key: { to_table: :users }
  end
end
