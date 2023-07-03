class CreditPack < ApplicationRecord
  validates :price, :credit_amount, presence: true

  has_many :line_items
  has_many :orders, through: :line_items
end
