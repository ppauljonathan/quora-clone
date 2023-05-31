class UsersController < ApplicationController
  before_action :set_user, except: %i[index]
  before_action :check_if_current_user, only: %i[edit update drafts destroy]
  before_action :current_user, only: %i[index show questions answers comments followers following]
  before_action :check_if_not_current_user, only: %i[follow unfollow]

  skip_before_action :authorize, only: %i[index show questions answers comments followers following]

  def answers
    @answers = @user.answers
                    .includes(:rich_text_content, :question)
                    .page(params[:page])
  end

  def comments
    @comments = @user.comments
                     .includes(:rich_text_content, :commentable)
                     .page(params[:page])
  end

  def destroy
    if @user.destroy
      redirect_to root_path, notice: 'User deleted Successfully'
    else
      render :edit
    end
  end

  def drafts
    @questions = @user.questions
                      .drafts
                      .includes(:user, :topics)
                      .page(params[:page])
  end

  def follow
    @user.followers << set_current_user
  rescue ActiveRecord::RecordNotUnique
    redirect_back_or_to @user, alert: 'already followed'
  else
    redirect_back_or_to @user, notice: 'successful'
  end

  def followers
    @followers = @user.followers
                      .includes(:profile_picture_attachment)
                      .page(params[:page])
                      .per(USER_CARDS_PER_PAGE)
  end

  def following
    @followings = @user.followings
                       .includes(:profile_picture_attachment)
                       .page(params[:page])
                       .per(USER_CARDS_PER_PAGE)
  end

  def unfollow
    @user.followers.delete set_current_user

    redirect_back_or_to @user, notice: 'successful'
  end

  def index
    @users = User.all
  end

  def questions
    @questions = @user.questions
                      .published
                      .includes(:user, :topics)
                      .page(params[:page])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'succesfully updated'
    else
      flash.now[:error] = @user.errors
      render :edit, status: 422
    end
  end

  private def check_if_not_current_user
    redirect_back_or_to root_path, notice: 'cannot follow self' if set_current_user == @user
  end

  private def check_if_current_user
    redirect_back_or_to root_path, notice: 'cannot access this path' unless current_user == @user
  end

  private def set_user
    @user = User.find_by_id(params[:id])
    redirect_to root_path, alert: 'user not found' unless @user
  end

  private def user_params
    params.require(:user).permit(:name, :profile_picture, :topic_list)
  end
end
