FactoryBot.define do
  factory :abuse_report do
    content { 'abusive content' }
    association :user
    trait :for_question do
      association :reportable, factory: :question
    end
  end
end
