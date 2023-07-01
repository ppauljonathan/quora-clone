class Order < ApplicationRecord
  STATUSES = {
    in_cart: 1,
    successful: 2,
    cancelled: 3
  }

  before_create :set_number

  belongs_to :user
  has_many :credit_transactions
  has_many :line_items, dependent: :destroy
  has_many :credit_packs, through: :line_items

  enum :status, STATUSES, default: :in_cart

  delegate :price, to: :credit_pack

  def checkout(success_url, cancel_url)
    transaction do
      credit_transaction = credit_transactions.create(user_id: user_id)
      stripe_session = generate_stripe_session(*generate_stripe_urls(success_url, cancel_url, credit_transaction.id))
      credit_transaction.update(stripe_session_id: stripe_session.id)
      stripe_session.url
    end
  end

  def clear_cart
    line_items.destroy_all
  end

  def set_amount
    update_columns(amount: line_items.pluck(:amount)
                             .reduce(:+))
  end

  def to_param
    number
  end

  def total_credits
    line_items.sum(&:total_credits)
  end

  private def generate_stripe_urls(success_url, cancel_url, transaction_id)
    success_url += "?transaction_id=#{transaction_id}"
    cancel_url += "?transaction_id=#{transaction_id}"

    [success_url, cancel_url]
  end

  private def generate_stripe_session(success_url, cancel_url)
    line_item_data = line_items.map(&:generate_stripe_checkout_data)

    Stripe::Checkout::Session.create({ success_url: success_url,
                                       cancel_url: cancel_url,
                                       mode: 'payment',
                                       line_items: line_item_data })
  end

  private def set_number
    number = nil
    loop do
      number = SecureRandom.base36
      break unless self.class.find_by_number(number)
    end
    self.number = number
  end
end
