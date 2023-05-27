class ReportsController < ApplicationController
  def create
    @report = set_current_user.reports.build(report_params)
    if @report.save
      redirect_back_or_to root_path, notice: 'reported'
    else
      redirect_back_or_to root_path, alert: 'something went wrong'
    end
  end

  private def report_params
    params.require(:report).permit(:reportable_type,
                                   :reportable_id,
                                   :content)
  end
end
