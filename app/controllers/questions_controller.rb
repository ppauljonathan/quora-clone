class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show]
  before_action :set_topics, only: %i[index search]
  before_action :check_credits, except: %i[index show]
  skip_before_action :authorize, only: %i[index show search]

  def index
    @questions = Question.includes(:user, :topics).order(created_at: :desc)

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
    @question = Question.new(question_params)
    @question.user = current_user

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
    @questions = Question.includes(:user, :topics).where('title LIKE ?', "%#{params[:title]}%")

    render :index
  end

  private def set_question
    @question = Question.find_by_url_slug(params[:url_slug])

    redirect_back_or_to root_path, alert: 'question not found' unless @question
  end

  private def set_topics
    @topics = ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end

  private def check_credits
    redirect_back_or_to root_path, notice: 'Not enough credit' unless current_user.credits > 1
  end

  private def question_params
    params.require(:question).permit(:title, :content, :topic_list)
  end
end
