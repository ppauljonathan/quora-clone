FactoryBot.define do
  factory :credit_log do
    association :user
    remark { 'some remart' }
    credit_amount { rand(-10..10) }
  end
end
