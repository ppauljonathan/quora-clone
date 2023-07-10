FactoryBot.define do
  factory :credit_transaction do
    association :order
    association :user
  end
end
