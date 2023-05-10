class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to email_verification_users_path, flash: { user_id: @user.id } }
      else
        format.html { render :new, notice: @user.errors, status: 422 }
      end
    end
  end

  def email_verification
    unless flash[:user_id]
      return redirect_to users_path, notice: 'Cannot access this path'
    end

    @user = User.find(flash[:user_id])

    respond_to do |format|
      format.html
    end
  end

  def validate_verification_token
    @user = User.find verification_token_params[:user_id]
    
    respond_to do |format|
      if @user.verification_token_valid? verification_token_params[:verification_token]
        format.html  { redirect_to users_path, notice: 'your email has been verified successfully' }
      else
        format.html do
          flash.now[:notice] = 'Incorrect OTP provided'
          render :email_verification, status: 422
        end
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

    def verification_token_params
      params.require(:validate).permit(:user_id, :verification_token)
    end
end
