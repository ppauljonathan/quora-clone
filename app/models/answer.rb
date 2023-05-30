class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content
  has_many :reports, as: :reportable
  has_many :votes, as: :votable

  validates :content, presence: true

  default_scope { order(net_upvote_count: :desc).where(reported_at: nil) }

  def vote_by_user(user)
    vote = votes.find_by(user: user)
    vote.nil? ? :unvote : vote.vote_type
  end
end
