# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = @book = Book.find(params[:book_id])
    @create_error_path = 'books/show'
  end
end
