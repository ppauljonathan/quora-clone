module PublishableContent
  extend ActiveSupport::Concern

  included do
    attr_accessor :save_as_draft

    before_save :save_as

    validates :content, presence: true

    has_rich_text :content

    scope :published, -> { where.not published_at: nil }
    scope :drafts, -> { where published_at: nil }
  end

  private def save_as
    self.published_at = save_as_draft ? nil : Time.now
  end
end