class User < ApplicationRecord
  include Tokenizable

  ROLES = {
    user: 0,
    admin: 1
  }.freeze
  CREDITS_ON_VERIFICATION = 5
  CREDITS_TO_ASK_QUESTION = 1

  has_secure_password
  has_one_attached :profile_picture
  acts_as_taggable_on :topics

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_verification_token, :generate_api_token
  after_commit :send_verification_email

  with_options join_table: :followings, class_name: 'User' do |assoc|
    assoc.has_and_belongs_to_many :followers, foreign_key: 'followee_id', association_foreign_key: 'follower_id'
    assoc.has_and_belongs_to_many :followees, foreign_key: 'follower_id', association_foreign_key: 'followee_id'
  end
  has_many :orders
  has_many :credit_transactions
  has_many :notifications
  has_many :abuse_reports
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :votes
  has_many :credit_logs

  default_scope { order(created_at: :desc).where(disabled_at: nil) }

  enum :role, ROLES, default: :user

  def can_ask_question?
    credits > CREDITS_TO_ASK_QUESTION
  end

  def enable
    update disabled_at: nil
  end

  def follows?(other_user_id)
    followee_ids.include? other_user_id
  end

  def resend_verification_mail
    update(verification_token: generate_token(:verification), verified_at: nil)
  end

  def send_reset_mail
    return false unless generate_reset_token

    UserMailer.with(user_id: id).reset_email.deliver_later
  end

  def disable
    update disabled_at: Time.now
  end

  def unfollow(user)
    follwees.delete user
  end

  def update_credits(amount, remark)
    credit_logs.create(credit_amount: amount, remark: remark)
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

  private def generate_api_token
    self.api_token = generate_token :api
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
