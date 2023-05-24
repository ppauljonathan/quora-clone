class Answer < ApplicationRecord
  validates :content, presence: true

  before_save :save_as

  belongs_to :user
  belongs_to :question
  has_rich_text :content

  scope :published, -> { where.not published_at: nil }
  scope :drafts, -> { where published_at: nil }

  private def save_as
    self.published_at = save_as_draft ? nil : Time.now
  end
end
