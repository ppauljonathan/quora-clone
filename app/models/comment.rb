class Comment < ApplicationRecord
  include AbuseReportable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_rich_text :content

  before_save { self.published_at = Time.now }

  validates :content, presence: true

  default_scope { order created_at: :desc }
end
