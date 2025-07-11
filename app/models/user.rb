class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :verification_attempts, dependent: :destroy
  has_many :ballots, dependent: :destroy
  belongs_to :delegate, class_name: 'User', optional: true
  has_many :delegators, class_name: 'User', foreign_key: :delegate_id

  # Phone number validation
  validates :phone, presence: true, uniqueness: true, if: -> { phone.present? }
  validate :phone_must_be_valid, if: -> { phone.present? }

  # Admin functionality
  scope :admins, -> { where(is_admin: true) }
  scope :regular_users, -> { where(is_admin: false) }

  def phone_must_be_valid
    unless Phonelib.valid?(phone)
      errors.add(:phone, 'is not a valid phone number')
    end
  end

  # Generates a random 6-digit code
  def generate_verification_code
    self.verification_code = rand(100_000..999_999).to_s
    self.verification_sent_at = Time.current
    save!
  end

  # Checks if the code is valid and not expired (10 min expiry)
  def verify_code?(code)
    return false if verification_code.blank? || verification_sent_at.blank?
    code == verification_code && verification_sent_at > 10.minutes.ago
  end

  # Mark phone as verified
  def mark_phone_verified!
    update!(phone_verified: true, verification_code: nil, verification_sent_at: nil)
  end

  # Track verification attempt
  def track_verification_attempt(code, success, request)
    verification_attempts.create!(
      phone: phone,
      code: code,
      success: success,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end

  # Check if user has exceeded rate limits
  def rate_limited?
    recent_attempts = verification_attempts.recent.count
    recent_attempts >= 5 # Max 5 attempts per 24 hours
  end

  # Admin helper methods
  def admin?
    is_admin?
  end

  def make_admin!
    update!(is_admin: true)
  end

  def remove_admin!
    update!(is_admin: false)
  end

  # Recursively get all users who ultimately delegate to this user
  def all_delegators
    result = []
    stack = delegators.to_a
    while stack.any?
      u = stack.pop
      result << u
      stack.concat(u.delegators)
    end
    result
  end
end
