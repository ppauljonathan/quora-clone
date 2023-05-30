class Vote < ApplicationRecord
  VOTE_TYPES = {
    upvote: -1,
    downvote: 1,
    unvote: 0
  }.freeze

  belongs_to :votable, polymorphic: true
  belongs_to :user

  enum :vote_type, VOTE_TYPES, default: :unvote
end
