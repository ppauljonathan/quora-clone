class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_rich_text :content
  has_many :reports, as: :reportable
  has_many :votes, as: :votable

  validates :content, presence: true

  default_scope { where(reported_at: nil) }

  def net_upvotes
    upvotes = votes.upvote.count
    downvotes = votes.downvote.count
    upvotes - downvotes
  end

  def vote_by_user(user)
    vote = votes.find_by(user: user)
    vote.nil? ? :unvote : vote.vote_type
  end
end
