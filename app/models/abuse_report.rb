class AbuseReport < ApplicationRecord
  MAX_REPORTED_BY = 5

  after_create_commit :check_reports

  belongs_to :reportable, polymorphic: true
  belongs_to :user
  has_rich_text :content

  validates :user_id, uniqueness: { scope: %i[reportable_type reportable_id] }
  validates :content, presence: true

  private def check_reports
    return unless reportable.abuse_reports.count > MAX_REPORTED_BY

    reportable.unpublish
  end
end
