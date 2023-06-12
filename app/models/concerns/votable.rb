module Votable
  extend ActiveSupport::Concern

  MIN_NET_UPVOTES_FOR_CREDIT = 5
  CREDITS_AWARDED = 1

  included do
    has_many :votes, as: :votable, dependent: :destroy

    default_scope { order(net_upvote_count: :desc) }

    before_update :set_credits, :remove_credits_if_unpublished
  end

  def set_net_upvotes
    upvotes = votes.upvote.count
    downvotes = votes.downvote.count
    update(net_upvote_count: upvotes - downvotes)
  end

  def vote_by_user(user)
    vote = votes.find { |v| v.user_id == user.id }
    vote&.vote_type
  end

  private def remove_credits_if_unpublished
    return unless changes[:published_at]
    return unless !published_at_was.nil? && net_upvote_count >= MIN_NET_UPVOTES_FOR_CREDIT

    user.decrement(:credits, 1)
  end

  private def set_credits
    return unless changes[:net_upvote_count]

    if net_upvote_count >= MIN_NET_UPVOTES_FOR_CREDIT && net_upvote_count_was <= MIN_NET_UPVOTES_FOR_CREDIT
      user.update_credits(CREDITS_AWARDED, "#{votable_type} vas upvoted")
    elsif net_upvote_count <= MIN_NET_UPVOTES_FOR_CREDIT && net_upvote_count_was >= MIN_NET_UPVOTES_FOR_CREDIT
      user.update_credits(-CREDITS_AWARDED, "#{votable_type} vas downvoted")
    end
  end
end
