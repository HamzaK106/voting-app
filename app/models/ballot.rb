class Ballot < ApplicationRecord
  belongs_to :user
  belongs_to :election
  has_many :ballot_items, dependent: :destroy

  validates :user_id, uniqueness: { scope: :election_id, message: 'can only vote once per election' }
  # delegated:boolean indicates if this ballot was cast by a delegate
  # delegation_chain:string stores the user ID chain for audit trail, e.g. '5>3>2'
end
