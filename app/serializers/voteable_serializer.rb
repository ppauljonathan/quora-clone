class VoteableSerializer < ActiveModel::Serializer
  attributes :net_vote_count

  def net_vote_count
    object.net_upvote_count
  end
end
