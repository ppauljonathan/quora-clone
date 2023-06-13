class Admin::QuestionsController < Admin::BaseController
  before_action :check_admin

  def index
    @questions = Question.published
                         .includes(:user)
                         .page(params[:page])
  end

  def unpublish
    @question = Question.find_by_url_slug(params[:url_slug])
    if @question.unpublish
      redirect_to admin_questions_path, notice: 'Question unpublished Successfully'
    else
      redirect_to admin_questions_path, alert: 'unpublishing failed'
    end
  end
end
