module Admin::UsersHelper
  def color_for(user)
    return '#8b06067a' if user.disabled_at?
    return 'rgba(121, 203, 62, 0.535)' if user.admin?

    ''
  end
end
