FactoryBot.define do
  factory :line_item do
    credit_pack_id { rand(1..3) }
    association :order
    quantity { 1 }
  end
end
