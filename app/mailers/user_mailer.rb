class UserMailer < ApplicationMailer
  before_action :find_user
  around_action :set_locale
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification_email.subject
  #
  def verification_email
    mail to: @user.email, subject: t('.subject')
  end

  def reset_email
    mail to: @user.email, subject: t('.subject')
  end

  private def find_user
    @user = User.find params[:user_id]
    raise 'User Not found' unless @user
  end

  private def set_locale
    I18n.with_locale :en do
      yield
    end
  end
end
