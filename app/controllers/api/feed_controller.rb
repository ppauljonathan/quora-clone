class Api::FeedController < ApplicationController
  before_action :set_user_from_token
  skip_before_action :authorize

  def index
    @questions = Question.published
                         .tagged_with(@user.topic_list, any: true)
                         .includes(:rich_text_content,
                                   :topics,
                                   { answers: [:rich_text_content,
                                               { comments: :rich_text_content }] },
                                   comments: :rich_text_content)

    render json: @questions
  end

  private def set_user_from_token
    @user = User.find_by_api_token(params[:token])

    render json: { error: 'token malformed' }, status: 422 unless @user
  end
end
