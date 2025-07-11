class VerificationAttempt < ApplicationRecord
  belongs_to :user
  
  validates :phone, presence: true
  validates :code, presence: true
  validates :success, inclusion: { in: [true, false] }
  
  scope :successful, -> { where(success: true) }
  scope :failed, -> { where(success: false) }
  scope :recent, -> { where('created_at > ?', 24.hours.ago) }
end
