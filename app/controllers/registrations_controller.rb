class RegistrationsController < ApplicationController
  before_action :redirect_if_logged_in
  skip_before_action :authorize

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, notice: 'Verify your email to login'
    else
      render :new, notice: @user.errors, status: 422
    end
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
