class Answer < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content
  has_many :reports, as: :reportable

  validates :content, presence: true

  default_scope { where(reported_at: nil) }
end
