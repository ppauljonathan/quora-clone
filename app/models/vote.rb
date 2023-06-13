class Vote < ApplicationRecord
  VOTE_TYPES = {
    upvote: -1,
    downvote: 1
  }.freeze

  belongs_to :votable, polymorphic: true
  belongs_to :user

  after_commit :votable_set_net_upvotes

  enum :vote_type, VOTE_TYPES

  def vote(type)
    return destroy if public_send "#{type}vote?"

    public_send "#{type}vote!"
  end

  private def votable_set_net_upvotes
    votable.set_net_upvotes
  end
end
