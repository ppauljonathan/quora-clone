class CommentSerializer < ActiveModel::Serializer
  attributes :content

  def content
    object.content.body.to_s
  end
end
