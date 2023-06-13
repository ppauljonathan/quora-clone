class Admin::BaseController < ApplicationController
  private def check_admin
    redirect_back_or_to root_path, notice: 'cannot access this path' unless current_user.admin?
  end
end