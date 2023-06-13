class Admin::UsersController < Admin::BaseController
  before_action :check_admin

  def index
    @users = User.all.page(params[:page])
  end
end
