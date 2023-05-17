class User < ApplicationRecord
  include Tokenizable

  validates :name, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password

  before_create :generate_verification_token
  after_create_commit :send_verification_email

  has_one_attached :profile_picture

  def verify
    update(verified_at: Time.now) unless verified?
  end

  def verified?
    verified_at?
  end

  def resend_verification_mail
    return false unless update(verification_token: generate_token(:verification), verified_at: nil)

    send_verification_email
  end

  def send_reset_mail
    return false unless generate_reset_token

    UserMailer.reset_email(id).deliver_later
  end

  private def generate_verification_token
    self.verification_token = generate_token :verification
  end

  private def send_verification_email
    UserMailer.verification_email(id).deliver_later
  end

  private def generate_reset_token
    update(reset_token: generate_token(:reset))
  end
end
