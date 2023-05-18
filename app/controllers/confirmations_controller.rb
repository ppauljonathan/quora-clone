class ConfirmationsController < ApplicationController
  before_action :redirect_if_logged_in
  skip_before_action :authorize

  def verify
    return unless params[:token]

    user = User.find_by_verification_token(params[:token])
    if user.try :verify
      redirect_to login_path, notice: 'email was verified successfully, you can log in now'
    else
      flash.now[:token_error] = 'Token was invalid, enter email to verify again'
      render :verify
    end
  end

  def resend
    user = User.find_by_email email_params
    if user.try :resend_verification_mail
      redirect_to login_path, notice: 'Verification email sent'
    else
      flash.now[:alert] = 'User with given email was not found'
      render :verify, status: 422
    end
  end

  private def email_params
    params.require(:email)
  end
end
