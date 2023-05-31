class Comment < ApplicationRecord
  include AbuseReportable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_rich_text :content
  has_many :reports, as: :reportable

  validates :content, presence: true

  default_scope { order(created_at: :desc).where.not(published_at: nil) }
end
