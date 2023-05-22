class QuestionsController < ApplicationController
  before_action :check_credits, except: %i[index show search]
  before_action :set_topics, :set_questions, only: %i[index search]
  before_action :set_question_details, only: :create
  before_action :set_unscoped_question, only: %i[edit destroy show update]
  before_action :check_access, only: %i[edit destroy update]
  before_action :check_if_editable, only: %i[edit update]
  before_action :check_if_question_published, only: %i[create update]

  skip_before_action :authorize, only: %i[index show search]

  def create
    if @question.save
      redirect_to root_path, notice: 'Question Created'
    else
      render :new
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Question deleted Successfully'
    else
      flash[:alert] = @question.errors
    end

    redirect_back_or_to user_path(@question.user_id)
  end

  def index
    return unless params[:topics]

    @questions = @questions.tagged_with params[:topics].keys, any: true
    @selected = params[:topics].keys
  end

  def new
    @question = Question.new
  end

  def search
    @questions = @questions.where('title LIKE ?', "%#{params[:title]}%")

    render :index
  end

  def show
    @user = @question.user
  end

  def update
    if @question.update(question_params)
      redirect_to root_path, notice: 'Question Updated'
    else
      render :edit
    end
  end

  private def check_access
    return if current_user == @question.user

    redirect_to root_path, notice: 'Cannot access this path'
  end

  private def check_credits
    redirect_back_or_to root_path, notice: 'Not enough credit' unless current_user.credits > 1
  end

  private def check_if_editable
    redirect_back_or_to question_path(@question), notice: 'cannot edit this question' unless @question.editable?
  end

  private def check_if_question_published
    return if params[:commit] == 'Save as Draft' || @question.published_at?

    @question.published_at = Time.now
  end

  private def question_params
    params.require(:question).permit(:title, :content, :topic_list, files: [])
  end

  private def set_questions
    @questions = Question.with_user.with_topics
  end

  private def set_question_details
    @question = Question.new(question_params)
    @question.user = current_user
  end

  private def set_topics
    @topics = ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end

  private def set_unscoped_question
    @question = Question.unscoped
                        .with_user
                        .with_topics
                        .with_files
                        .with_answers
                        .find_by_url_slug(params[:url_slug])
  end
end
