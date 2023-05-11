class ConfirmationsController < ApplicationController
  def verify
    unless params[:id] && params[:token]
      return render :verify
    end

    user = User.find(params[:id])
    if user.verification_token_valid? params[:token]
      flash.now[:notice] = 'email was verified successfully, you can log in now'
      render 'sessions/new'
    else
      flash.now[:error] = 'the token was not valid'
      render 'sessions/new'
    end
  end

  def resend
    user = User.find_by_email email_params

    if user
      user.resend_verification_mail
      redirect_to login_path, notice: 'Please verify your email before logging in, an email with a verification link has been sent to your email id'
    else
      flash.now[:notice] = 'User with given email was not found'
      render :verify, status: 422
    end
  end

  private

    def email_params
      params.require(:email)
    end
end
