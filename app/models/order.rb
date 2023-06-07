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

  enum :status, STATUSES, default: :in_cart

  delegate :price, to: :credit_pack

  def to_param
    number
  end

  def generate_stripe_session(success_url, cancel_url)
    Stripe::Checkout::Session.create({ success_url: success_url,
                                       cancel_url: cancel_url,
                                       mode: 'payment',
                                       line_items: [{
                                         price_data: {
                                           currency: 'inr',
                                           unit_amount: (price * 100).to_i,
                                           product_data: {
                                             name: "#{credit_pack.credit_amount} Credit Pack",
                                             description: credit_pack.description
                                           }
                                         },
                                         quantity: 1
                                       }] })
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
