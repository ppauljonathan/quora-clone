class Question < ApplicationRecord
  include PublishableContent

  URL_SLUG_WORD_LENGTH = 7

  validates :title, uniqueness: true, presence: true
  validates :content, presence: true
  validates :topic_list, presence: true
  validates :url_slug, presence: true

  before_validation :generate_url_slug

  default_scope { order created_at: :desc }

  belongs_to :user
  acts_as_taggable_on :topics
  has_many_attached :files
  has_many :answers
  has_many :comments, as: :commentable

  def author?(author)
    author == user
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

  private def words_in_title
    title.split.count
  end
end
