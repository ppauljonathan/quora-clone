module ApplicationHelper
  def highlighted_link(name, class1, class2, options = {}, html_options = {})
    html_options[:class] = request.path == options ? class2 : class1
    link_to name, options, html_options
  end
end
