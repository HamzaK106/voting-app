class Election < ApplicationRecord
  has_many :candidates, dependent: :destroy
  has_many :ballots, dependent: :destroy

  validates :title, presence: true
  validates :starts_at, :ends_at, presence: true
end
