class Vote < ApplicationRecord
  VOTE_TYPES = {
    upvote: -1,
    downvote: 1
  }.freeze

  belongs_to :votable, polymorphic: true
  belongs_to :user

  after_commit :votable_set_net_upvotes

  enum :vote_type, VOTE_TYPES

  private def votable_set_net_upvotes
    votable.set_net_upvotes
  end
end
