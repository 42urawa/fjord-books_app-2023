# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def create
    @comment = Comment.new(user_id: current_user.id, body: comment_params[:body], commentable: comment_params[:commentable])
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

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
    params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type)
  end
end
