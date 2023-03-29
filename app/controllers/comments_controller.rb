# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def create
    model_class = request.path.split('/')[1].singularize.capitalize.constantize
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = model_class.find(request.path.split('/')[2].to_i)

    if @comment.save
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @commentable = @comment.commentable
      @comments = @commentable.comments
      rendering_path = @comment.commentable_type.downcase.pluralize << '/show'
      render rendering_path, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def correct_user
    redirect_to root_url if current_user.id != @comment.user_id
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
