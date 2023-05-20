class UsersController < ApplicationController
  before_action :current_user

  before_action :set_user, except: %i[index]
  before_action :check_if_current_user, only: %i[edit update drafts destroy]

  skip_before_action :authorize, only: %i[index show]

  def destroy
    if @user.destroy
      redirect_to root_path, notice: 'User deleted Successfully'
    else
      redirect_to user_path(@user.id), alert: @user.errors
    end
  end

  def drafts
    @questions = Question.unscoped.where(user_id: @user.id, published_at: nil)
    render :show
  end

  def edit
    @topics = @user.topic_list.join(', ')
  end

  def index
    @users = User.all
  end

  def questions
    @questions = Question.where(user_id: @user.id)
    render :show
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'succesfully updated'
    else
      flash.now[:error] = @user.errors
      render :edit, status: 422
    end
  end

  private def check_if_current_user
    redirect_back_or_to root_path, notice: 'cannot access this path' unless current_user == @user
  end

  private def set_user
    @user = User.includes(:topics).find_by_id(params[:id])
    redirect_to root_path, alert: 'user not found' unless @user
  end

  private def user_params
    params.require(:user).permit(:name, :profile_picture, :topic_list)
  end
end
