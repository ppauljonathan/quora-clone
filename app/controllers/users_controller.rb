class UsersController < ApplicationController
  before_action :set_user
  before_action :check_if_current_user, only: %i[edit update drafts destroy]
  before_action :check_if_not_current_user, only: %i[follow unfollow]

  skip_before_action :authorize, only: %i[index show questions answers comments followers followees]

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
    if @user.disable
      redirect_back_or_to root_path, notice: 'User deleted Successfully'
    else
      render :edit, status: 422
    end
  end

  def drafts
    @questions = @user.questions
                      .drafts
                      .includes(:user, :topics)
                      .page(params[:page])
  end

  def follow
    if current_user.follow(@user)
      redirect_back_or_to @user, notice: 'successful'
    else
      redirect_back_or_to @user, alert: 'already followed'
    end
  end

  def followers
    @followers = @user.followers
                      .includes(:profile_picture_attachment)
                      .page(params[:page])
  end

  def followees
    @followees = @user.followees
                       .includes(:profile_picture_attachment)
                       .page(params[:page])
  end

  def unfollow
    current_user.unfollow @user

    redirect_back_or_to @user, notice: 'successful'
  end

  def questions
    @questions = @user.questions
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
    redirect_back_or_to root_path, notice: 'cannot follow self' if current_user == @user
  end

  private def check_if_current_user
    redirect_back_or_to root_path, notice: 'cannot access this path' unless current_user == @user || current_user.admin?
  end

  private def set_user
    @user = User.find_by_id(params[:id])
    redirect_to root_path, alert: 'user not found' unless @user
  end

  private def user_params
    params.require(:user).permit(:name, :profile_picture, :topic_list)
  end
end
