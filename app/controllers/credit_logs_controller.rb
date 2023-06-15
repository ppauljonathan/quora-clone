class CreditLogsController < ApplicationController
  def index
    @credit_logs = current_user.credit_logs
  end
end
