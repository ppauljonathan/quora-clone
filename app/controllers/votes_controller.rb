class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_vote

  def downvote
    if @vote.vote :down
      render json: { vote_type: @vote.vote_type,
                     net_vote_count: @vote.votable.net_upvote_count,
                     destroyed: @vote.destroyed? },
             status: 200
    else
      render json: { message: 'unprocessable entity' }, status: 422
    end
  end

  def upvote
    if @vote.vote :up
      render json: { vote_type: @vote.vote_type,
                     net_vote_count: @vote.votable.net_upvote_count,
                     destroyed: @vote.destroyed? },
             status: 200
    else
      render json: { message: 'unprocessable entity' }, status: 422
    end
  end

  private def vote_params
    params.require(:vote).permit(:votable_type, :votable_id)
  end

  private def set_vote
    @vote = Vote.find_or_initialize_by(votable_type: vote_params[:votable_type],
                                       votable_id: vote_params[:votable_id],
                                       user: current_user)
  end
end
