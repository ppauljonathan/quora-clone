class AnswersController < ApplicationController
  before_action :check_if_draft_question, :set_answer_details, only: %i[create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :check_if_answer_published, only: %i[create update]

  def create
    flash[:alert] = @answer.errors unless @answer.save

    redirect_to question_path(@answer.question.url_slug), notice: 'created successfully'
  end

  def destroy
    if @answer.destroy
      redirect_to question_path(@answer.question.url_slug), notice: 'deleted successfully'
    else
      flash[:alert] = @answer.errors
      render :edit
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question.url_slug), notice: 'updated successfully'
    else
      flash[:alert] = @answer.errors
      render :edit
    end
  end

  private def answer_params
    params.require(:answer).permit(:content, :question_id)
  end

  private def check_if_answer_published
    return if params[:commit] == 'Save as Draft' || @answer.published_at?

    @answer.published_at = Time.now
  end

  private def check_if_draft_question
    question = Question.find_by_id(answer_params[:question_id])

    redirect_to root_path notice: 'Cannot access this path' unless question.published_at?
  end

  private def set_answer
    @answer = Answer.find_by_id(params[:id])
    redirect_back_or_to current_user, alert: 'comment not found' unless @answer
  end

  private def set_answer_details
    @answer = Answer.new(answer_params)
    @answer.user = current_user
  end
end
