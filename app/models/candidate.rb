class Candidate < ApplicationRecord
  belongs_to :election
  has_many :ballot_items, dependent: :destroy

  validates :name, presence: true
end
