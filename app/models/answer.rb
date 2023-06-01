class Answer < ApplicationRecord
  MIN_NET_UPVOTES_FOR_CREDIT = 5

  include Votable
  include AbuseReportable

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content

  validates :content, presence: true

  before_update :set_credits

  default_scope { where.not(published_at: nil) }

  private def set_credits
    return unless changes[:net_upvote_count]

    if net_upvote_count >= MIN_NET_UPVOTES_FOR_CREDIT && net_upvote_count_was <= MIN_NET_UPVOTES_FOR_CREDIT
      user.increment!(:credits, 1)
    elsif net_upvote_count <= MIN_NET_UPVOTES_FOR_CREDIT && net_upvote_count_was >= MIN_NET_UPVOTES_FOR_CREDIT
      user.decrement!(:credits, 1)
    end
  end
end
