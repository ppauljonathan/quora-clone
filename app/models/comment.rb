class Comment < ApplicationRecord
  include Votable
  include AbuseReportable

  has_rich_text :content

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true

  default_scope { where.not(published_at: nil) }
end
