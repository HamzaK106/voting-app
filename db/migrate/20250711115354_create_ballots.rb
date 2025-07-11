class CreateBallots < ActiveRecord::Migration[7.1]
  def change
    create_table :ballots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :election, null: false, foreign_key: true

      t.timestamps
    end
  end
end
