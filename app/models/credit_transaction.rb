class CreditTransaction < ApplicationRecord
  STATUSES = {
    pending: 0,
    successful: 1,
    cancelled: 2
  }.freeze

  belongs_to :order
  belongs_to :user

  enum :status, STATUSES, default: :pending

  default_scope { order created_at: :desc }

  def unpaid?
    stripe_payment_status = Stripe::Checkout::Session.retrieve(stripe_session_id).to_h[:payment_status]
    stripe_payment_status == 'unpaid'
  end

  def mark_success
    transaction do
      successful!
      order.successful!
      user.update_credits(@order.credit_pack.credit_amount, 'purchased credits from store')
    end
  end
end
