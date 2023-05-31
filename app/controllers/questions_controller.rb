class QuestionsController < ApplicationController
  before_action :check_credits, except: %i[index show comments]
  before_action :set_question, only: %i[edit destroy comments show update]
  before_action :can_view?, only: %i[show comments]
  before_action :can_edit?, only: %i[edit destroy update]
  before_action :current_user, only: %i[index show comments]

  skip_before_action :authorize, only: %i[index show comments]

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to root_path, notice: 'Question Created'
    else
      render :new
    end
  end

  def comments
    @comments = @question.comments
                         .page(params[:page])
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
                              .page(params[:page])
                              .includes(:user, :topics)
                              .ransack(params[:q])
    @questions = @search_results.result

    @questions = @questions.tagged_with(params[:topics]&.keys || helpers.topics,
                                        any: true)
    @selected = params[:topics]&.keys
  end

  def new
    @question = Question.new
  end

  def show
    @answers = @question.answers
                        .page(params[:page])
  end

  def update
    if @question.update(question_params)
      redirect_to root_path, notice: 'Question Updated'
    else
      render :edit
    end
  end

  private def can_edit?
    return if @question.author? current_user

    redirect_back_or_to root_path, alert: 'Cannot access this path'
  end

  private def can_view?
    return if @question.author?(current_user) || @question.published_at?

    redirect_back_or_to root_path, alert: 'Cannot access this path'
  end

  private def check_credits
    return if current_user.can_ask_question?

    redirect_back_or_to root_path, notice: 'Not enough credit'
  end

  private def check_if_editable
    redirect_back_or_to question_path(@question), notice: 'cannot edit this question' unless @question.editable?
  end

  private def question_params
    params.require(:question).permit(:title, :content, :topic_list, :save_as_draft, files: [])
  end

  private def set_question
    @question = Question.includes(:topics,
                                  :files_attachments,
                                  :rich_text_content,
                                  { user: :profile_picture_attachment },
                                  { answers: :rich_text_content },
                                  { comments: :rich_text_content })
                        .find_by_url_slug(params[:url_slug])
  end
end
