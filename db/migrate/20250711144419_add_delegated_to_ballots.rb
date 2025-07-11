class AddDelegatedToBallots < ActiveRecord::Migration[7.1]
  def change
    add_column :ballots, :delegated, :boolean, default: false
    add_column :ballots, :delegation_chain, :string
  end
end
