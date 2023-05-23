# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/verification_email
  def verification_email
    id = User.first.id
    UserMailer.verification_email(id)
  end

end
