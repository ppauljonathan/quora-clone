class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    flash[:notice] = @comment.save ? 'created successfully' : 'error in creating comment'
    redirect_to @comment.commentable
  end

  def destroy
    if @comment.destroy
      redirect_to @comment.commentable, notice: 'deleted successfully'
    else
      render :edit, status: 422
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: 'updated successfully'
    else
      render :edit, status: 422
    end
  end

  private def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end

  private def set_comment
    @comment = Comment.includes(:rich_text_content,
                                commentable: [:rich_text_content,
                                              { user: :profile_picture_attachment },
                                              :files_attachments])
                      .find_by_id(params[:id])
    redirect_back_or_to current_user, alert: 'comment not found' unless @comment
  end
end
