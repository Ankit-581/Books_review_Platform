require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  # Sample user creation method
  def create_sample_user
    User.create!(
      email: "test_user_#{rand(1000)}@example.com",
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  # Sample book creation method
  def create_sample_book(attributes = {})
    Book.create!({
      title: "Test Book #{rand(1000)}",
      author: "Test Author",
      publication_year: 2023,
      isbn: "123456789#{rand(10)}"
    }.merge(attributes))
  end

  # Simulate user authentication
  def sign_in_user
    @current_user = create_sample_user
    allow(controller).to receive(:current_user).and_return(@current_user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  before do
    sign_in_user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns paginated books" do
      15.times { create_sample_book }
      get :index
      expect(assigns(:books).size).to be <= 12
    end

    it "allows searching" do
      book = create_sample_book(title: "Specific Search Book")
      get :index, params: { q: { title_cont: "Specific Search" } }
      expect(assigns(:books)).to include(book)
    end
  end

  describe "GET #show" do
    let(:book) { create_sample_book }
    let(:user) { create_sample_user }

    it "returns a successful response" do
      get :show, params: { id: book.id }
      expect(response).to be_successful
    end

    it "loads book reviews" do
      3.times do
        Review.create!(
          book: book,
          user: user,
          rating: 3,  # Provide a valid numeric rating
          content: "Test review #{rand(1000)}"
        )
      end

      get :show, params: { id: book.id }
      expect(assigns(:reviews).size).to eq(3)
    end
  end

  describe "GET #new" do
    it "requires authentication" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it "initializes a new book" do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end
  end

  describe "POST #create" do
    let(:valid_book_params) do
      {
        title: "New Book",
        author: "New Author",
        publication_year: 2023,
        isbn: "1234567890"
      }
    end

    context "with valid attributes" do
      it "creates a new book" do
        expect {
          post :create, params: { book: valid_book_params }
        }.to change(Book, :count).by(1)
      end

      it "redirects to the new book" do
        post :create, params: { book: valid_book_params }
        expect(response).to redirect_to(Book.last)
      end
    end

    context "with invalid attributes" do
      it "rejects books with invalid publication year" do
        invalid_params = valid_book_params.merge(publication_year: 1700)
        post :create, params: { book: invalid_params }
        expect(assigns(:book).errors[:publication_year]).to be_present
      end

      it "rejects books with invalid ISBN" do
        invalid_params = valid_book_params.merge(isbn: '123')
        post :create, params: { book: invalid_params }
        expect(assigns(:book).errors[:isbn]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    let(:book) { create_sample_book }

    context "with valid attributes" do
      it "updates the book" do
        patch :update, params: { id: book.id, book: { title: "Updated Title" } }
        book.reload
        expect(book.title).to eq("Updated Title")
      end
    end

    context "with invalid attributes" do
      it "does not update the book" do
        original_title = book.title
        patch :update, params: { id: book.id, book: { title: "" } }
        book.reload
        expect(book.title).to eq(original_title)
      end
    end
  end
end




# require "test_helper"

# class BooksControllerTest < ActionDispatch::IntegrationTest
#   test "should get index" do
#     get books_index_url
#     assert_response :success
#   end

#   test "should get show" do
#     get books_show_url
#     assert_response :success
#   end

#   test "should get new" do
#     get books_new_url
#     assert_response :success
#   end

#   test "should get create" do
#     get books_create_url
#     assert_response :success
#   end
# end
