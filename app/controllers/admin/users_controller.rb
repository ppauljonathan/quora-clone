class Admin::UsersController < ApplicationController
  before_action :check_admin
  before_action :set_user, only: %i[enable disable]
  def index
    @users = User.unscoped.all.page(params[:page])
  end

  def enable
    flash[:notice] = @user.enable ? 'user enabled successfully' : 'error in enabling user'
    redirect_to admin_users_path
  end

  def disable
    flash[:notice] = @user.soft_destroy ? 'user disabled successfully' : 'error in disabling user'
    redirect_to admin_users_path
  end

  def set_user
    @user = User.unscoped.find_by_id(params[:id])
    redirect_back_or_to admin_users_path, notice: 'user not found' unless @user
  end
end
