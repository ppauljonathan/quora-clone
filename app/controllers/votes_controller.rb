class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_vote
  def downvote
    @vote.vote_type = @vote.downvote? ? :unvote : :downvote
    respond_to do |format|
      if @vote.save
        @vote.votable.set_net_upvotes
        format.json do
          render json: { vote_type: @vote.vote_type, net_vote_count: @vote.votable.net_upvote_count }, status: 200
        end
      else
        format.json {}
      end
    end
  end

  def upvote
    @vote.vote_type = @vote.upvote? ? :unvote : :upvote
    respond_to do |format|
      if @vote.save
        @vote.votable.set_net_upvotes
        format.json do
          render json: { vote_type: @vote.vote_type, net_vote_count: @vote.votable.net_upvote_count }, status: 200
        end
      else
        format.json { render json: { message: 'unprocessable entity' }, status: 422 }
      end
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