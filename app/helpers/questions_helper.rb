module QuestionsHelper
  def should_display_edit_button?(question)
    current_user == question.user && request.url.match(users_path)
  end
end
