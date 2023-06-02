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

  private def set_number
    number = nil
    loop do
      number = SecureRandom.base36
      break unless self.class.find_by_number(number)
    end
    self.number = number
  end
end
