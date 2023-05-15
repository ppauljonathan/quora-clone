class TopicsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def search
    search_regexp = Regexp.new "^#{params[:term]}", 'i'
    all_topics = ActsAsTaggableOn::Tag.pluck :name

    respond_to do |format|
      format.json { render json: all_topics.grep(search_regexp) }
    end
  end
end
