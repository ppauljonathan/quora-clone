class ApplicationController < ActionController::Base
  before_action :authorize

  private def redirect_if_logged_in
    redirect_back_or_to root_path if current_user
  end

  private def authorize
    redirect_to login_url unless current_user
  end

  private def current_user
    @current_user ||= User.find_by_id(cookies.signed[:user_id])
  end
end
