class ApplicationController < ActionController::Base
  before_action :authorize

  private def redirect_to_homepage_if_logged_in
    redirect_to users_path if session[:user_id]
  end

  private def authorize
    return if session[:user_id]
    return redirect_to login_url unless cookies.signed[:user_id]

    session[:user_id] = cookies.signed[:user_id]
  end
end
