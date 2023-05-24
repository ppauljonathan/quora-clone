class Comment < ApplicationRecord
  include PublishableContent

  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
