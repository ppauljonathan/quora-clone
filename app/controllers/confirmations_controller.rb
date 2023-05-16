class ConfirmationsController < ApplicationController
  before_action :redirect_to_homepage_if_logged_in
  skip_before_action :authorize

  def verify
    unless params[:id] && params[:token]
      return render :verify
    end

    user = User.find(params[:id])
    if user.verification_token_valid? params[:token]
      redirect_to login_path, notice: 'email was verified successfully, you can log in now'
    else
      redirect_to login_path, flash: { token_error: 'the token was not valid' }
    end
  end

  def resend
    user = User.find_by_email email_params

    if user
      user.resend_verification_mail
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
