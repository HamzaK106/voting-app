class CreateBallotItems < ActiveRecord::Migration[7.1]
  def change
    create_table :ballot_items do |t|
      t.references :ballot, null: false, foreign_key: true
      t.references :candidate, null: false, foreign_key: true
      t.integer :rank

      t.timestamps
    end
  end
end
