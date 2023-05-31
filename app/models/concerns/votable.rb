module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    default_scope { order(net_upvote_count: :desc) }
  end

  def vote_by_user(user)
    vote = votes.find { |v| v.user_id == user.id }
    vote.nil? ? :unvote : vote.vote_type
  end
end