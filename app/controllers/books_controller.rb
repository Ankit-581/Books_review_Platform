# app/controllers/books_controller.rb
class BooksController < ApplicationController
  before_action :set_book, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result
              .order(created_at: :desc)
              .page(params[:page])
              .per(12)
  end

  def show
    @reviews = @book.reviews
                    .includes(:user)
                    .order(created_at: :desc)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    # Additional custom validations
    if @book.publication_year.to_i < 1800 || @book.publication_year.to_i > Time.current.year
      @book.errors.add(:publication_year, 'must be between 1800 and current year')
    end

    # ISBN format validation
    unless @book.isbn.match?(/^\d{10}$/)   #  use this regex expression i.e. (/^(?:\d{10}|\d{13})$/) to use correct ISBN in future
      @book.errors.add(:isbn, 'must be a valid 10 or 13 digit ISBN')
    end

    if @book.save
      flash[:success] = "Book '#{@book.title}' was successfully created."
      redirect_to @book, notice: 'Book was successfully created.'
    else
      flash[:error] = "Unable to create book. #{@book.errors.full_messages.join(', ')}."
      redirect_to new_book_path
    end
  end

    def update
    if @book.update(book_params)
      flash[:success] = "Book '#{@book.title}' was successfully updated."
      redirect_to @book
    else
      flash[:error] = 'Unable to update book. Please check the form.'
      render :edit
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
    :title,
    :author,
    :publication_year,
    :isbn
    )
  end
end
