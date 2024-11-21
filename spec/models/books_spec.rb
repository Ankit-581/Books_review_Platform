# require "test_helper"

# class BookTest < ActiveSupport::TestCase
#   # test "the truth" do
#   #   assert true
#   # end
# end

# spec/models/book_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { Book.create(title: "Sample Book", author: "John Doe", publication_year: 2020, isbn: "978-3-16-148410-0") }
  let(:user) { User.create(email: "jane.doe@example.com", password: "password") }
  let(:review) { Review.create(rating: 5, content: "Great book!", book: book, user: user) }

  # Associations
  it { should have_many(:reviews).dependent(:destroy) }
  it { should have_many(:reviewers).through(:reviews).source(:user) }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:publication_year) }
  it do
    should validate_numericality_of(:publication_year)
      .only_integer
      .is_greater_than(1800)
      .is_less_than_or_equal_to(Time.current.year)
  end
  it { should validate_presence_of(:isbn) }
  it do
    should allow_value('978-3-16-148410-0').for(:isbn)
    should allow_value('0-306-40615-2').for(:isbn)
    should_not allow_value('invalid-isbn').for(:isbn)
  end

  # Methods
  describe '#update_average_rating' do
    it 'updates the average_rating attribute based on reviews' do
      review1 = Review.create(rating: 4, content: "Good book!", book: book, user: user)
      review2 = Review.create(rating: 4, content: "Excellent book!", book: book, user: user)

      book.update_average_rating

      expect(book.average_rating).to eq(4)  # Average of 4 and 5
    end
  end

  describe '#reviewed_by?' do
    it 'returns true if the user has reviewed the book' do
      review  # This creates a review for the book by the user

      expect(book.reviewed_by?(user)).to be_truthy
    end

    it 'returns false if the user has not reviewed the book' do
      another_user = User.create(email: "another.user@example.com", password: "password")

      expect(book.reviewed_by?(another_user)).to be_falsey
    end
  end

  # Class methods (ransackable)
  describe '.ransackable_attributes' do
    it 'returns the correct list of attributes for ransack' do
      expect(Book.ransackable_attributes).to include('author', 'isbn', 'title')
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct list of associations for ransack' do
      expect(Book.ransackable_associations).to include('reviews', 'reviewers')
    end
  end
end
