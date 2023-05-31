module AbuseReportable
  extend ActiveSupport::Concern

  included do
    has_many :reports, as: :reportable
  end
end