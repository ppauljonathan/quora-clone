class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_verification_token
  after_create_commit :send_verification_email
  
  def verification_token_valid?(token)
    return false if verified_at || token != verification_token

    update verified_at: Time.now
  end

  private

    def generate_verification_token
      self.verification_token = (rand * (10 ** 7)).to_i
    end

    def send_verification_email
      UserMailer.verification_email(id).deliver_later
    end
end
