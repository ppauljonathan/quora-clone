class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, except: :destroy
  before_action :set_user_from_email, :authenticate_user, :check_verified_user, only: :create
  skip_before_action :authorize

  REMEMBER_ME_EXPIRES = 24.weeks.from_now

  def create
    expires_at = user_params[:remember_me] ? REMEMBER_ME_EXPIRES : nil

    cookies.signed[:user_id] = { value: @user.id, expires: expires_at }

    redirect_to root_path
  end

  def destroy
    cookies.delete :user_id
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
    return if @user.authenticate user_params[:password]

    redirect_to login_path, alert: 'Invalid email/password combination'
  end

  private def check_verified_user
    return if @user.verified?

    redirect_to confirmation_path, flash: { token_error: 'User is not verified yet' }
  end
end
