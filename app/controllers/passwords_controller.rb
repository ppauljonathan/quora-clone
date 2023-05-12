class PasswordsController < ApplicationController
  before_action :redirect_to_homepage_if_logged_in
  skip_before_action :authorize

  def create
    user = User.find_by_email email_params

    if user
      user.send_reset_mail
      redirect_to(
        reset_password_path,
        notice: 'An email to reset password has been sent to the email, if you have not received the email, trigger the action again'
      )
    else
      redirect_to reset_password_path, notice: 'User with given email was not found'
    end
  end

  def edit
    unless params[:id] && params[:token]
      return redirect_to reset_password_path, notice: 'Cannot access this path'
    end

    @user = User.find(params[:id])
    unless @user.reset_token_valid? params[:token]
      return redirect_to reset_password_path, notice: 'the token was not valid, please initiate reset password action again'
    end
  end

  def update
    @user = User.find(user_params[:id])

    if @user.update(password: user_params[:password])
      redirect_to login_path, notice: 'password has been reset successfully, please login'
    else
      redirect_to reset_password_edit_path error: @user.errors
    end
  end

  private def email_params
    params.require(:email)
  end

  private def user_params
    params.require(:user)
  end
end
