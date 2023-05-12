class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification_email.subject
  #
  def verification_email(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: 'Confirm your email address'
  end

  def reset_email(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: 'Reset your password'
  end
end
