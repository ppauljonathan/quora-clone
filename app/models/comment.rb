class Comment < ApplicationRecord
  include AbuseReportable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_rich_text :content

  validates :content, presence: true

  default_scope { order created_at: :desc }
end
