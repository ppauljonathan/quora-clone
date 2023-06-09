class AnswersController < ApplicationController
  before_action :check_if_draft_question, only: %i[create]
  before_action :set_answer, only: %i[show edit update destroy]

  def create
    @answer = current_user.answers.build(answer_params)
    flash[:notice] = @answer.save ? 'created successfully' : 'error in creating answer'
    redirect_to question_path(@answer.question.url_slug)
  end

  def destroy
    if @answer.destroy
      redirect_to question_path(@answer.question.url_slug), notice: 'deleted successfully'
    else
      render :edit, status: 422
    end
  end

  def show
    @comments = @answer.comments
                       .includes({ user: :profile_picture_attachment },
                                 :rich_text_content,
                                 votes: :user)
                       .page(params[:page])
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question.url_slug), notice: 'updated successfully'
    else
      render :edit, status: 422
    end
  end

  private def answer_params
    params.require(:answer).permit(:content, :question_id)
  end

  private def check_if_draft_question
    question = Question.find_by_id(answer_params[:question_id])

    redirect_to root_path notice: 'Cannot access this path' if question.draft?
  end

  private def set_answer
    @answer = Answer.includes(:rich_text_content,
                              { question: [:rich_text_content,
                                           { user: :profile_picture_attachment },
                                           :files_attachments] })
                    .find_by_id(params[:id])
    redirect_back_or_to current_user, alert: 'answer not found' unless @answer
  end
end
