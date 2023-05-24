module ApplicationHelper
  def highlighted_link(name, class1, class2, options = {}, html_options = {})
    html_options[:class] = request.path == options ? class2 : class1
    link_to name, options, html_options
  end

  def topics
    @topics ||= ActsAsTaggableOn::Tag.for_context(:topics).distinct.pluck(:name)
  end

  def topic_list_for(model)
    @topic_list_for ||= model.topic_list.join(',')
  end
end
