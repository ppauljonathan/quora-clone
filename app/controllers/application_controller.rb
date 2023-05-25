class ApplicationController < ActionController::Base
  before_action :authorize

  private def authorize
    redirect_to login_url, alert: 'Please Log in to continue' unless current_user
  end

  private def current_user
    @current_user ||= User.find_by_id(cookies.signed[:user_id])
  end

  private def redirect_if_logged_in
    redirect_back_or_to root_path if current_user
  end
end
