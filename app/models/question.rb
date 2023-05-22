class Question < ApplicationRecord
  URL_SLUG_WORD_LENGTH = 7

  before_save :generate_url_slug

  belongs_to :user

  acts_as_taggable_on :topics

  has_rich_text :content
  has_many_attached :files
  has_many :answers, dependent: :destroy_async

  default_scope { where.not(published_at: nil).order(created_at: :desc) }
  scope :with_user, -> { includes user: :profile_picture_attachment }
  scope :with_topics, -> { includes :topics }
  scope :with_files, -> { includes :files_attachments }
  scope :with_answers, -> { includes answers: [:rich_text_content, { user: :profile_picture_attachment }] }
  scope :with_content, -> { includes :rich_text_content }

  validates :title, uniqueness: true, presence: true
  validates :content, presence: true
  validates :topic_list, presence: true

  def editable?
    answers.none?
  end

  def published_answers
    answers.published
  end

  def to_param
    url_slug
  end

  private def generate_url_slug
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
