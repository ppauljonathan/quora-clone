class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :credit_pack

  validates :quantity, numericality: { in: (1..20) }

  before_save :update_amount
  after_commit :update_order_amount

  def update_quantity_by(number)
    update(quantity: quantity + number.to_i)
  end

  def generate_stripe_checkout_data
    { price_data: {
        currency: 'inr',
        unit_amount: amount_in_cents,
        product_data: {
          name: "#{credit_pack.credit_amount} Credit_pack",
          description: credit_pack.description
        }
      },
      quantity: quantity }
  end

  def total_credits
    credit_pack.credit_amount * quantity
  end

  private def amount_in_cents
    ((amount / quantity) * 100).to_i
  end

  private def update_amount
    self.amount = credit_pack.price * quantity
  end

  private def update_order_amount
    order.set_amount
  end
end
