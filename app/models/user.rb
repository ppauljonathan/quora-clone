class User < ApplicationRecord
  include Tokenizable

  ROLES = {
    user: 0,
    admin: 1
  }.freeze
  CREDITS_ON_VERIFICATION = 5
  CREDITS_TO_ASK_QUESTION = 1

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_verification_token
  after_commit :send_verification_email

  has_secure_password
  has_one_attached :profile_picture
  acts_as_taggable_on :topics

  has_many :questions
  has_many :answers
  has_many :comments

  enum :role, ROLES, default: :user

  def can_ask_question?
    credits > CREDITS_TO_ASK_QUESTION
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
    return if verified?

    update(verification_token: nil,
           verified_at: Time.now,
           credits: CREDITS_ON_VERIFICATION)
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
