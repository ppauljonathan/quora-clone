class Admin::UsersController < ApplicationController
  before_action :check_admin
  def index
    @users = User.all.page(params[:page])
  end
end
