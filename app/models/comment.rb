class Comment < ApplicationRecord
  include Votable
  include AbuseReportable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_rich_text :content

  validates :content, presence: true

  default_scope { where.not(published_at: nil) }
end
