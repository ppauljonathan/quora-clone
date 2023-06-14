class Answer < ApplicationRecord
  include AbuseReportable

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content

  validates :content, presence: true

  default_scope { order created_at: :desc }
end
