class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, except: :destroy
  before_action :set_user_from_email, :authenticate_user, :check_verified_user, only: :create
  skip_before_action :authorize

  def create
    cookies.signed[:user_id] = { value: @user.id, expires: 24.weeks.from_now } if user_params[:remember_me]

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    cookies.delete :user_id
    session[:user_id] = nil
    redirect_to login_path
  end

  private def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end

  private def set_user_from_email
    @user = User.find_by(email: user_params[:email])
    redirect_to login_path, alert: 'Invalid email/password combination' unless @user
  end

  private def authenticate_user
    return if @user.try(:authenticate, user_params[:password])

    redirect_to login_path, alert: 'Invalid email/password combination'
  end

  private def check_verified_user
    return if @user.verified?

    redirect_to login_path, flash: { token_error: 'User is not verified yet' }
  end
end
