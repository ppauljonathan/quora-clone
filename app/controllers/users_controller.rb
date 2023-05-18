class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :check_if_current_user, only: %i[edit update]
  skip_before_action :authorize, only: %i[index show]

  skip_before_action :authorize, only: %i[index show]
  before_action :current_user, only: %i[index show]

  def index
    @users = User.all
  end

  def show
    @topics = @user.topic_list
  end

  def edit
    @topics = @user.topic_list.join(', ')
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'succesfully updated'
    else
      flash.now[:error] = @user.errors
      render :edit, status: 422
    end
  end

  private def set_user
    @user = User.find_by_id(params[:id])
    redirect_to root_path, alert: 'user not found' unless @user
  end

  private def user_params
    params.require(:user).permit(:name, :profile_picture, :topic_list)
  end

  private def check_if_current_user
    redirect_back_or_to root_path, notice: 'cannot edit this user' unless current_user == @user
  end
end
