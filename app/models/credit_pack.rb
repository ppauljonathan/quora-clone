class CreditPack < ApplicationRecord
  validates :price, :credit_amount, presence: true

  has_many :orders
end
