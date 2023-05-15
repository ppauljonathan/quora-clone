class Question < ApplicationRecord
  URL_SLUG_WORD_LENGTH = 7

  before_create :generate_url_slug

  belongs_to :user

  def to_param
    url_slug
  end

  private def generate_url_slug
    sample_slug = title.truncate_words(URL_SLUG_WORD_LENGTH)
                       .parameterize

    duplicate_slugs_count = self.class.where('url_slug LIKE ?', "#{sample_slug}%").count

    self.url_slug = sample_slug + "-#{duplicate_slugs_count + 1}"
  end
end
