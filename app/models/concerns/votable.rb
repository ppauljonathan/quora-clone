module Votable
  extend ActiveSupport::Concern

  MIN_NET_UPVOTES_FOR_CREDIT = 5
  CREDITS_AWARDED = 1

  included do
    has_many :votes, as: :votable, dependent: :destroy

    default_scope { order(net_upvote_count: :desc) }

    after_commit :set_credits, if: :net_upvote_count_previously_changed?
  end

  def downvote(user_id)
    vote = votes.find_or_create_by(user_id: user_id)
    return vote.destroy if vote.downvote?

    vote.downvote!
  end

  def set_net_upvotes
    vote_counts = votes.group(:vote_type).count
    upvotes = vote_counts['upvote'] || 0
    downvotes = vote_counts['downvote'] || 0
    update(net_upvote_count: upvotes - downvotes)
  end

  def upvote(user_id)
    vote = votes.find_or_create_by(user_id: user_id)
    return vote.destroy if vote.upvote?

    vote.upvote!
  end

  def vote_by_user(user)
    vote = votes.find { |v| v.user_id == user.id }
    vote&.vote_type
  end

  private def set_credits
    if net_upvote_count == MIN_NET_UPVOTES_FOR_CREDIT
      user.update_credits(CREDITS_AWARDED, "#{self.class} upvoted")
    elsif net_upvote_count < MIN_NET_UPVOTES_FOR_CREDIT && net_upvote_count_previously_was >= MIN_NET_UPVOTES_FOR_CREDIT
      user.update_credits(-CREDITS_AWARDED, "#{self.class} downvoted")
    end
  end
end
