module CommentsHelper
  def commented_on(comment)
    output = 'ON: '.html_safe
    commented_on = comment.commentable.class
    if commented_on == Question
      output += link_to comment.commentable.title, comment.commentable
    elsif commented_on == Answer
      output += link_to answer_path(comment.commentable.id), comment.commentable
    end
    output
  end
end
