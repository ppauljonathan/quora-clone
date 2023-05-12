class UsersController < ApplicationController
  def index
    @users = User.all
  end

  private def set_user
    @user = User.find(session[:user_id])
  end
end
