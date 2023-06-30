class Api::TopicsController < ApplicationController
  skip_before_action :authorize

  def index
    @questions = Question.tagged_with(params[:topic])
                         .includes(:rich_text_content,
                                   :topics,
                                   { answers: [:rich_text_content,
                                               { comments: :rich_text_content }] },
                                   comments: :rich_text_content)

    render json: @questions
  end
end
