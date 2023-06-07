class QuestionSerializer < ActiveModel::Serializer
  attributes :title, :content, :topics

  has_many :comments
  has_many :answers

  def content
    object.content.body.to_s
  end

  def topics
    object.topics.pluck(:name)
  end
end
