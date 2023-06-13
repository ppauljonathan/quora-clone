class Comment < ApplicationRecord
  include Votable
  include AbuseReportable

  has_rich_text :content

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true

  default_scope { order created_at: :desc }
end
