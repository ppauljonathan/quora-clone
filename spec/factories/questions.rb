FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "question #{n}" }
    content { 'Question Content' }
    topic_list { 'questions' }
    user
  end
end
