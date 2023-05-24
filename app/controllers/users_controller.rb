class UsersController < ApplicationController
  before_action :set_user, except: %i[index]
  before_action :check_if_current_user, only: %i[edit update drafts destroy]
  before_action :set_answers, only: :answers

  skip_before_action :authorize, only: %i[index show questions answers comments]

  def answers
    render :show
  end

  def destroy
    if @user.destroy
      redirect_to root_path, notice: 'User deleted Successfully'
    else
      redirect_to user_path(@user.id), alert: @user.errors
    end
  end

  def drafts
    @questions = Question.drafts.includes(:user, :topics).where user_id: @user.id
  end

  def index
    @users = User.all
  end

  def questions
    @questions = Question.published.includes(:user, :topics).where(user_id: @user.id)
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
    @user = User.includes(:profile_picture_attachment, :topics).find_by_id(params[:id])
    redirect_to root_path, alert: 'user not found' unless @user
  end

  private def set_answers
    @answers = @user.answers.includes(:rich_text_content)
    @answers = @answers.published unless @user == current_user
  end

  private def user_params
    params.require(:user).permit(:name, :profile_picture, :topic_list)
  end
end
