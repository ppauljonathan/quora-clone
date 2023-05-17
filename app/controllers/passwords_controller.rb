class PasswordsController < ApplicationController
  before_action :redirect_if_logged_in
  skip_before_action :authorize
  before_action :set_user_from_email, only: :create

  def create
    return unless @user.send_reset_mail

    flash[:notice] = 'Email to reset password has been sent, trigger the action again if not received'
    redirect_to reset_password_path
  end

  def edit
    @user = User.find_by_reset_token params[:token] if params[:token]
    return if @user

    redirect_to reset_password_path, notice: 'the token was not valid, please initiate reset password action again'
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

  private def set_user_from_email
    @user = User.find_by_email(email_params)
    redirect_to reset_password_path, alert: 'User with given email not found' unless @user
  end
end
