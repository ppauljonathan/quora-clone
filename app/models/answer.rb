class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content
  has_many :reports, as: :reportable

  validates :content, presence: true

  default_scope { order(created_at: :desc).where(reported_at: nil) }
end
