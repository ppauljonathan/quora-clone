class UserMailer < ApplicationMailer
  before_action :find_user
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification_email.subject
  #
  def verification_email
    mail to: @user.email, subject: 'Confirm your email address'
  end

  def reset_email
    mail to: @user.email, subject: 'Reset your password'
  end

  private def find_user
    @user = User.find params[:user_id]
    raise 'User Not found' unless @user
  end
end
