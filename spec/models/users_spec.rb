# require "test_helper"

# class UserTest < ActiveSupport::TestCase
#   # test "the truth" do
#   #   assert true
#   # end
# end


require 'rails_helper'

RSpec.describe User, type: :model do
  # Associations
  describe 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:reviewed_books).through(:reviews).source(:book) }
  end

  # Validations
  describe 'validations' do
    it 'is valid with a unique email' do
      user = User.create!(email: 'user1@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is invalid with a duplicate email' do
      User.create!(email: 'user1@example.com', password: 'password')
      user = User.new(email: 'user1@example.com', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid without an email' do
      user = User.new(password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  # Devise functionality tests (authentication)
  describe 'Devise authentication' do
    let(:user) { User.create!(email: 'user1@example.com', password: 'password') }

    it 'validates the password' do
      user = User.create!(email: 'user1@example.com', password: 'password')
      expect(user.valid_password?('password')).to be true
      expect(user.valid_password?('wrong_password')).to be false
    end

    it 'responds to database_authenticatable' do
      expect(user).to respond_to(:valid_password?)
    end

    it 'responds to recoverable' do
      expect(user).to respond_to(:send_reset_password_instructions)
    end

    it 'responds to rememberable' do
      expect(user).to respond_to(:remember_me)
    end
  end

  # Books reviewed by user (through reviews)
  describe 'reviewed_books' do
    let(:user) { User.create!(email: 'user1@example.com', password: 'password') }
    let(:book1) { Book.create!(title: 'Book One', author: 'Author One', publication_year: 2020, isbn: "978-3-16-148410-0") }
    let(:book2) { Book.create!(title: 'Book Two', author: 'Author Two', publication_year: 2020, isbn: "978-3-16-148410-1") }

    it 'returns books the user has reviewed' do
      review1 = Review.create!(user: user, book: book1, rating: 5, content: 'Great book!')
      review2 = Review.create!(user: user, book: book2, rating: 4, content: 'Good book!')

      expect(user.reviewed_books).to include(book1, book2)
    end

    it 'does not include books not reviewed by the user' do
      book3 = Book.create!(title: 'Book Three', author: 'Author Three', publication_year: 2020, isbn: "978-3-16-148410-0")
      expect(user.reviewed_books).not_to include(book3)
    end
  end
end
