class User < ApplicationRecord
  validates :name, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password

  before_create :generate_verification_token
  after_create_commit :send_verification_email

  has_one_attached :profile_picture

  def verification_token_valid?(token)
    return false if verified? || token != verification_token

    update(verified_at: Time.now, credits: (credits + 5))
  end

  def verified?
    verified_at?
  end

  def resend_verification_mail
    generate_verification_token
    update verified_at: nil
    send_verification_email
  end

  def reset_token_valid?(token)
    token == reset_token
  end

  def send_reset_mail
    generate_reset_token
    UserMailer.reset_email(id).deliver_later
  end

  private def generate_verification_token
    self.verification_token = SecureRandom.base64
  end

  private def send_verification_email
    UserMailer.verification_email(id).deliver_later
  end

  private def generate_reset_token
    update(reset_token: SecureRandom.base64)
  end
end
