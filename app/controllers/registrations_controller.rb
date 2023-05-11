class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'Please verify your email to log in, an email with a verification link has been sent to your registered email address' }
      else
        format.html { render :new, notice: @user.errors, status: 422 }
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end
end
