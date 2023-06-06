class Question < ApplicationRecord
  include AbuseReportable

  URL_SLUG_WORD_LENGTH = 7

  attr_accessor :save_as_draft

  validates :title, uniqueness: true, presence: true
  validates :content, presence: true
  validates :topic_list, presence: true
  validates :url_slug, presence: true

  before_validation :generate_url_slug
  before_save :save_as
  after_create_commit :post_question_notification

  default_scope { order(created_at: :desc) }
  scope :published, -> { where.not published_at: nil }
  scope :drafts, -> { where published_at: nil }

  belongs_to :user
  acts_as_taggable_on :topics
  has_many_attached :files
  has_many :answers
  has_many :comments, as: :commentable
  has_many :notifications
  has_rich_text :content

  def author?(author)
    author == user
  end

  def draft?
    !published_at?
  end

  def editable?
    comments.none? && answers.none? && reports.none?
  end

  def to_param
    url_slug
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['title']
  end

  private def generate_url_slug
    return if url_slug
    return self.url_slug = title.parameterize if words_in_title < URL_SLUG_WORD_LENGTH

    sample_slug = title.truncate_words(URL_SLUG_WORD_LENGTH)
                       .parameterize
    duplicate_slugs_count = self.class.where('url_slug LIKE ?', "#{sample_slug}%").count
    self.url_slug = sample_slug + "-#{duplicate_slugs_count + 1}"
  end

  private def post_question_notification
    ActionCable.server.broadcast('question_posted',
                                 { id: id,
                                   topics: topic_list,
                                   poster_name: user.name })
  end

  private def save_as
    self.published_at = save_as_draft ? nil : Time.now
  end

  private def words_in_title
    title.split.count
  end
end
