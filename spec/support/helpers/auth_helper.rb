module AuthHelper
  def sign_in(user)
    post login_path(user: { email: user.email, password: user.password })
  end
end
