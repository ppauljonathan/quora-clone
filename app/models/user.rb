class User < ApplicationRecord
  include Tokenizable

  ROLES = {
    user: 0,
    admin: 1
  }.freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_verification_token
  after_commit :send_verification_email

  has_secure_password
  has_one_attached :profile_picture
  has_many :questions, dependent: :nullify
  acts_as_taggable_on :topics

  enum :role, ROLES, default: :user

  def can_ask_question?
    credits > 1
  end

  def resend_verification_mail
    update(verification_token: generate_token(:verification), verified_at: nil)
  end

  def send_reset_mail
    return false unless generate_reset_token

    UserMailer.with(user_id: id).reset_email.deliver_later
  end

  def verified?
    verified_at?
  end

  def verify
    update(verification_token: nil, verified_at: Time.now, credits: 5) unless verified?
  end

  private def generate_reset_token
    update(reset_token: generate_token(:reset))
  end

  private def generate_verification_token
    self.verification_token = generate_token :verification
  end

  private def send_verification_email
    return unless verification_token && !verified?

    UserMailer.with(user_id: id).verification_email.deliver_later
  end
end
