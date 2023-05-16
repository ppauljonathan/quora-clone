class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show]

  def index
    @questions = Question.order(created_at: :desc)

    if params[:topics]
      @questions = @questions.tagged_with params[:topics].keys, any: true 
      @selected = params[:topics].keys
    end

    @topics = ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end

  def show
    @user = @question.user
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private def set_question
    @question = Question.find_by_url_slug(params[:url_slug])

    redirect_back_or_to root_path, alert: 'question not found' unless @question
  end
end
