class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show]
  before_action :set_topics, only: %i[index search]
  skip_before_action :authorize, only: %i[index show search]

  def index
    @questions = Question.includes(:users, :topics).order(created_at: :desc)

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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def search
    @questions = Question.includes(:users, :topics).where('title LIKE ?', "%#{params[:title]}%")

    render :index
  end

  private def set_question
    @question = Question.find_by_url_slug(params[:url_slug])

    redirect_back_or_to root_path, alert: 'question not found' unless @question
  end

  private def set_topics
    @topics = ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end
end
