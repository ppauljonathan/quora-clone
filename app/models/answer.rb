class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_rich_text :content

  scope :with_content, -> { includes :rich_text_content }
  scope :with_question, lambda {
    includes(question: [:rich_text_content,
                        { user: :profile_picture_attachment },
                        :files_attachments])
  }
  scope :published, -> { where.not published_at: nil }

  validates :content, presence: true
end
