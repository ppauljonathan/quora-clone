class RegistrationsController < ApplicationController
  before_action :redirect_if_logged_in

  skip_before_action :authorize

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:token_notice] = t('.verify')
      redirect_to login_path
    else
      render :new, notice: @user.errors, status: 422
    end
  end

  def new
    @user = User.new
  end

  private def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
