class Report < ApplicationRecord
  MAX_REPORTED_BY = 5

  after_create_commit :check_reports

  has_rich_text :content

  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: %i[reportable_type reportable_id] }
  validates :content, presence: true

  private def check_reports
    return unless reportable.reports.count > MAX_REPORTED_BY

    reportable.update(published_at: nil)
  end
end
