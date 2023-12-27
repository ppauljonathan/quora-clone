FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test user #{n}" }
    sequence(:email) { |n| "user#{n}@quoraclone.com" }
    password { 'secret' }
    credits { 5 }
    verified_at { Time.now }
  end

  trait :admin do
    role { :admin }
  end

  trait :disabled do
    disabled_at { Time.now }
  end
end
