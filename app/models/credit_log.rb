class CreditLog < ApplicationRecord
  belongs_to :user

  default_scope { order created_at: :desc }

  after_create_commit :change_user_credits

  private def change_user_credits
    user.increment!(:credits, credit_amount)
  end
end
