class ConfirmationsController < ApplicationController
  before_action :redirect_if_logged_in
  before_action :check_token, :set_user_from_verification_token, only: :verify
  before_action :set_user_from_email, :check_if_already_verified, only: :resend

  skip_before_action :authorize

  def resend
    return unless @user.resend_verification_mail

    flash[:token_notice] = 'Verification email sent'
    redirect_to login_path
  end

  def verify
    redirect_to login_path, notice: 'email was verified successfully, you can log in now' if @user.verify
  end

  private def check_if_already_verified
    redirect_to login_path, alert: 'User is already verified' if @user.verified?
  end

  private def check_token
    render :verify unless params[:token]
  end

  private def email_params
    params.require(:email)
  end

  private def set_user_from_email
    @user = User.find_by_email email_params

    return if @user

    flash.now[:notice] = 'User with given email was not found'
    render :verify, status: 422
  end

  private def set_user_from_verification_token
    @user = User.find_by_verification_token(params[:token])

    return if @user

    flash.now[:alert] = 'Token was invalid, enter email to verify again'
    render :verify, status: 422
  end
end
