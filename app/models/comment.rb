class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_rich_text :content
  has_many :reports, as: :reportable

  validates :content, presence: true

  default_scope { order(created_at: :desc).where(reported_at: nil) }
end
