class Answer < ApplicationRecord
  include PublishableContent

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
end
