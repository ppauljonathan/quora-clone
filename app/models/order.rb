class Order < ApplicationRecord
  STATUSES = {
    in_cart: 1,
    successful: 2,
    cancelled: 3
  }

  before_create :set_number

  belongs_to :credit_pack
  belongs_to :user
  has_many :credit_transactions

  validates :amount, numericality: { greater_than_or_equal_to: 0.1 }

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

  def to_param
    number
  end

  private def generate_stripe_urls(success_url, cancel_url, transaction_id)
    success_url += "?transaction_id=#{transaction_id}"
    cancel_url += "?transaction_id=#{transaction_id}"

    [success_url, cancel_url]
  end

  private def generate_stripe_session(success_url, cancel_url)
    line_items = [{ price_data: { currency: 'inr',
                                  unit_amount: (price * 100).to_i,
                                  product_data: { name: "#{credit_pack.credit_amount} Credit Pack",
                                                  description: credit_pack.description } },
                    quantity: 1 }]

    Stripe::Checkout::Session.create({ success_url: success_url,
                                       cancel_url: cancel_url,
                                       mode: 'payment',
                                       line_items: line_items })
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
