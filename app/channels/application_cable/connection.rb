module ApplicationCable
  class Connection < ActionCable::Connection::Base

    def current_user
      @current_user ||= User.find_by_id(cookies.signed[:user_id])
    end
  end
end
