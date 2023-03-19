# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def new
  end

  def create
    p "テストテストテスト"
    p comment_params
    p comment_params[:body]
    p comment_params[:commentable]
    @comment = Comment.new(user_id: current_user.id, body: comment_params[:body], commentable: comment_params[:commentable])
    @comment = Comment.new(comment_params)
    p "テストテスト"
    p @comment

    respond_to do |format|
      if @comment.save
        format.html { redirect_to report_url(@comment.commentable), notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to polymorphic_url(@comment.commentable), notice: "Report was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to polymorphic_url(@comment.commentable)
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
    # params.require(:comment).permit(:body, :commentable)
  end

end
