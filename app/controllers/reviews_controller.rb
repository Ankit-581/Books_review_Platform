# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_book
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @review = @book.reviews.build
  end

  def create
    @review = @book.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @book, notice: 'Review was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @book, notice: 'Review was successfully deleted.'
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  def authorize_user
    unless @review.user == current_user
      redirect_to @book, alert: 'You are not authorized to perform this action.'
    end
  end
end