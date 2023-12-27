FactoryBot.define do
  factory :answer do
    association :user
    association :question
    content { 'Answer Content' }
  end
end
