# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books or /books.json
  def index
    @books = Book.order(:id).page(params[:page])
  end

  # GET /books/1 or /books/1.json
  def show
    @comments = @commentable.comments.order(:id)
    @comment = Comment.new
  end

  # GET /books/new
  def new
    @commentable = Book.new
  end

  # GET /books/1/edit
  def edit; end

  # POST /books or /books.json
  def create
    @commentable = Book.new(book_params)

    respond_to do |format|
      if @commentable.save
        format.html { redirect_to book_url(@commentable), notice: t('controllers.common.notice_create', name: Book.model_name.human) }
        format.json { render :show, status: :created, location: @commentable }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @commentable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @commentable.update(book_params)
        format.html { redirect_to book_url(@commentable), notice: t('controllers.common.notice_update', name: Book.model_name.human) }
        format.json { render :show, status: :ok, location: @commentable }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @commentable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @commentable.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: t('controllers.common.notice_destroy', name: Book.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @commentable = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :memo, :author, :picture)
  end
end
