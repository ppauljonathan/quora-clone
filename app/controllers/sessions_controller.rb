class SessionsController < ApplicationController
  before_action :redirect_to_homepage_if_logged_in, except: :destroy
  skip_before_action :authorize

  def create
    user = User.find_by(email: user_params[:email])

    unless user.try(:authenticate, user_params[:password])
      flash.now[:error] = 'Invalid email/password combination'
      return render :new, status: 422
    end

    unless user.verified?
      flash.now[:token_error] = 'User is not verified yet'
      return render :new, status: 422
    end

    cookies.signed[:user_id] = { value: user.id, expires: 24.weeks.from_now } if user_params[:remember_me]

    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    cookies.delete :user_id
    session[:user_id] = nil
    redirect_to login_url
  end

  private def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end
end
