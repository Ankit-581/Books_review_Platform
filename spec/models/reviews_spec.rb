# require "test_helper"

# class ReviewTest < ActiveSupport::TestCase
#   # test "the truth" do
#   #   assert true
#   # end
# end

# spec/controllers/reviews_controller_spec.rb
# spec/controllers/reviews_controller_spec.rb
require 'rails_helper'

RSpec.describe Review, type: :model do
  # Associations
  it { should belong_to(:user) }
  it { should belong_to(:book) }

  # Validations
  describe 'validations' do
    it 'is valid with a rating between 1 and 5' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 4,
        content: 'Great book, I really enjoyed it!'
      )
      expect(review).to be_valid
    end

    it 'is invalid without a rating' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        content: 'Great book, I really enjoyed it!'
      )
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it 'is invalid with a rating less than 1' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 0,
        content: 'Great book, I really enjoyed it!'
      )
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include('must be greater than or equal to 1')
    end

    it 'is invalid with a rating greater than 5' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 6,
        content: 'Great book, I really enjoyed it!'
      )
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include('must be less than or equal to 5')
    end

    it 'is valid with content between 10 and 1000 characters' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 5,
        content: 'A' * 100 # valid content length
      )
      expect(review).to be_valid
    end

    it 'is invalid with content shorter than 10 characters' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 5,
        content: 'Short'
      )
      expect(review).not_to be_valid
      expect(review.errors[:content]).to include('is too short (minimum is 10 characters)')
    end

    it 'is invalid with content longer than 1000 characters' do
      review = Review.new(
        user: User.create!(email: 'user1@example.com',  password: "password"),
        book: Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0"),
        rating: 5,
        content: 'A' * 1001
      )
      expect(review).not_to be_valid
      expect(review.errors[:content]).to include('is too long (maximum is 1000 characters)')
    end

    it 'is invalid if the user has already reviewed the same book' do
      user = User.create!(email: 'user1@example.com',  password: "password")
      book = Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0")

      Review.create!(user: user, book: book, rating: 5, content: 'Great book!')

      duplicate_review = Review.new(user: user, book: book, rating: 4, content: 'Good book!')
      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:user_id]).to include('has already reviewed this book')
    end
  end

  # Callbacks
  describe 'callbacks' do
    it 'calls update_book_average_rating after save' do
      book = Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0")
      user = User.create!(email: 'user1@example.com',  password: "password")

      # Ensure the update_average_rating method is called
      expect(book).to receive(:update_average_rating)

      Review.create!(user: user, book: book, rating: 5, content: 'Great book!')
    end

    it 'calls update_book_average_rating after destroy' do
      book = Book.create!(title: 'Sample Book', author: 'Author', publication_year: 2020, isbn: "978-3-16-148410-0")
      user = User.create!(email: 'user1@example.com',  password: "password")

      review = Review.create!(user: user, book: book, rating: 5, content: 'Great book!')

      # Ensure the update_average_rating method is called when the review is destroyed
      expect(book).to receive(:update_average_rating)

      review.destroy
    end
  end
end
