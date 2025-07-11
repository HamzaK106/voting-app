class BallotItem < ApplicationRecord
  belongs_to :ballot
  belongs_to :candidate

  validates :rank, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
