class AnswerSerializer < ActiveModel::Serializer
  attributes :content

  has_many :comments

  def content
    object.content.body.to_s
  end
end
