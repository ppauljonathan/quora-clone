class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_vote

  def downvote
    if @voteable.downvote current_user.id
      render json: @voteable, serializer: VoteableSerializer, status: 200
    else
      render json: { message: 'unprocessable entity' }, status: 422
    end
  end

  def upvote
    if @voteable.upvote current_user.id
      render json: @voteable, serializer: VoteableSerializer, status: 200
    else
      render json: { message: 'unprocessable entity' }, status: 422
    end
  end

  private def vote_params
    params.require(:vote).permit(:votable_type, :votable_id)
  end

  private def set_vote
    @voteable = vote_params[:votable_type].constantize.find_by_id(vote_params[:votable_id])
  end
end
