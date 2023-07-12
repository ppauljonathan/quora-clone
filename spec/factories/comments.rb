FactoryBot.define do
  factory :comment do
    association :user
    association :commentable
    content { 'Comment Content' }
  end
end
