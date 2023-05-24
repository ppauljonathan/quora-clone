class QuestionsController < ApplicationController
  before_action :current_user

  before_action :check_credits, except: %i[index show]
  before_action :set_question, :check_access, only: %i[edit destroy show update]

  skip_before_action :authorize, only: %i[index show]

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to root_path, notice: 'Question Created'
    else
      render :new
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Question deleted Successfully'
      redirect_to user_path(@question.user_id)
    else
      render :edit
    end
  end

  def index
    @search_results = Question.published
                              .includes(:user, :topics)
                              .ransack(params[:q])
    @questions = @search_results.result

    return unless params[:topics]

    @questions = @questions.tagged_with params[:topics].keys, any: true
    @selected = params[:topics].keys
  end

  def new
    @question = Question.new
  end

  def update
    if @question.update(question_params)
      redirect_to root_path, notice: 'Question Updated'
    else
      render :edit
    end
  end

  private def check_access
    return if @question.can_be_accessed_by?(current_user,
                                            request.path,
                                            request.method)

    redirect_back_or_to root_path, notice: 'Cannot access this path'
  end

  private def check_credits
    return if current_user.can_ask_question?

    redirect_back_or_to root_path, notice: 'Not enough credit'
  end

  private def question_params
    params.require(:question).permit(:title, :content, :topic_list, :save_as_draft, files: [])
  end

  private def set_question
    @question = Question.includes(:topics, :files_attachments, :rich_text_content, user: :profile_picture_attachment)
                        .find_by_url_slug(params[:url_slug])
  end
end
