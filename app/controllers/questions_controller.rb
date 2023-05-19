class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show]
  before_action :set_topics, :set_questions, only: %i[index search]
  before_action :check_credits, except: %i[index show]
  before_action :set_question_details, :check_if_question_published, only: :create

  skip_before_action :authorize, only: %i[index show serch]
  before_action :current_user, only: %i[index show search]

  def index
    return unless params[:topics]

    @questions = @questions.tagged_with params[:topics].keys, any: true
    @selected = params[:topics].keys
  end

  def show
    @user = @question.user
  end

  def new
    @question = Question.new
  end

  def create
    if @question.save
      redirect_to root_path, notice: 'Question Created'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def search
    @questions = @questions.where('title LIKE ?', "%#{params[:title]}%")

    render :index
  end

  private def set_question
    @question = Question.with_user.with_topics.with_files.find_by_url_slug(params[:url_slug])

    redirect_back_or_to root_path, alert: 'question not found' unless @question
  end

  private def set_questions
    @questions = Question.with_user.with_topics
  end

  private def set_question_details
    @question = Question.new(question_params)
    @question.user = current_user
  end

  private def check_if_question_published
    return if params[:commit] == 'Save As Draft'

    @question.published_at = Time.now
  end

  private def set_topics
    @topics = ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end

  private def check_credits
    redirect_back_or_to root_path, notice: 'Not enough credit' unless current_user.credits > 1
  end

  private def question_params
    params.require(:question).permit(:title, :content, :topic_list, files: [])
  end
end
