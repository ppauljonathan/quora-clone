# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/verification_email
  def verification_email
    id = User.first.id
    UserMailer.with(user_id: id).verification_email
  end

  def reset_email
    id = User.first.id
    UserMailer.with(user_id: id).reset_mail
  end
end
