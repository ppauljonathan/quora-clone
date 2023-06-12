module AbuseReportable
  extend ActiveSupport::Concern

  included do
    has_many :abuse_reports, as: :reportable
    default_scope { where.not published_at: nil }
  end

  def unpublish
    update(published_at: nil)
  end
end