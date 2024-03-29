module AbuseReportable
  extend ActiveSupport::Concern

  MIN_NET_UPVOTES_FOR_CREDIT = 5
  CREDITS_AWARDED = 1

  included do
    attr_accessor :save_as_draft

    has_many :abuse_reports, as: :reportable

    default_scope { where.not published_at: nil }

    before_save :publish, unless: :save_as_draft
  end

  def unpublish
    if self.class.name != 'Question' && net_upvote_count >= MIN_NET_UPVOTES_FOR_CREDIT
      user.update_credits(-CREDITS_AWARDED, "#{self.class} unpublished")
    end

    update_column(:published_at, nil)
  end

  private def publish
    self.published_at = Time.now
  end
end
