class Question < ApplicationRecord
  URL_SLUG_WORD_LENGTH = 7

  validates :title, uniqueness: true, presence: true
  validates :content, presence: true
  validates :topic_list, presence: true
  validates :url_slug, presence: true
  validate :user_can_ask_question?

  before_validation :generate_url_slug, on: :create
  before_save :publish, unless: :save_as_draft

  default_scope { order created_at: :desc }
  scope :published, -> { where.not published_at: nil }
  scope :drafts, -> { where published_at: nil }

  belongs_to :user
  acts_as_taggable_on :topics
  has_rich_text :content
  has_many_attached :files
  has_many :answers

  attr_accessor :save_as_draft

  def author?(author)
    author.id == user.id
  end

  def draft?
    !published_at?
  end

  def editable?
    answers.none?
  end

  def to_param
    url_slug
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title]
  end

  private def generate_url_slug
    return self.url_slug = title.parameterize if words_in_title < URL_SLUG_WORD_LENGTH

    sample_slug = title.truncate_words(URL_SLUG_WORD_LENGTH)
                       .parameterize
    duplicate_slugs_count = self.class.where('url_slug LIKE ?', "#{sample_slug}%").count
    self.url_slug = sample_slug + "-#{duplicate_slugs_count + 1}"
  end

  private def user_can_ask_question?
    return if user.can_ask_question?

    errors.add :base, :invalid, message: 'You do not heve enough credits'
  end

  private def publish
    self.published_at = Time.now
  end

  private def words_in_title
    title.split.count
  end
end
