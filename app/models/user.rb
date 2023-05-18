class User < ApplicationRecord
  include Tokenizable

  ROLES = {
    user: 0,
    admin: 1
  }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password

  before_create :generate_verification_token
  after_commit :send_verification_email

  has_one_attached :profile_picture

  enum :role, ROLES, default: :user

  def verify
    update(verification_token: nil, verified_at: Time.now) unless verified?
  end

  def verified?
    verified_at?
  end

  def resend_verification_mail
    update(verification_token: generate_token(:verification), verified_at: nil)
  end

  def send_reset_mail
    return false unless generate_reset_token

    UserMailer.with(user_id: id).reset_email.deliver_later
  end

  private def generate_verification_token
    self.verification_token = generate_token :verification
  end

  private def send_verification_email
    return unless verification_token && !verified?

    UserMailer.with(user_id: id).verification_email.deliver_later
  end

  private def generate_reset_token
    update(reset_token: generate_token(:reset))
  end
end
