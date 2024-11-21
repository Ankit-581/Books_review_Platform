# spec/controllers/reviews_controller_spec.rb
require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }
  let(:book) { Book.create!(title: 'Sample Book', author: 'John Doe', publication_year: 2020, isbn: "978-3-16-148410-0") }
  let(:review_params) { { rating: 4, content: 'Great book!' } }
  let(:review) { book.reviews.create!(rating: 4, content: 'Great book!', user: user) }

  before do
    sign_in(user)
  end

  describe 'GET #new' do
    it 'assigns a new review to @review' do
      get :new, params: { book_id: book.id }
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new review and redirects to the book' do
        expect {
          post :create, params: { book_id: book.id, review: review_params }
        }.to change(Review, :count).by(1)
        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to eq('Review was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a review and renders the new template' do
        invalid_params = { rating: nil, content: nil }
        post :create, params: { book_id: book.id, review: invalid_params }
        expect(Review.count).to eq(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested review to @review' do
      get :edit, params: { book_id: book.id, id: review.id }
      expect(assigns(:review)).to eq(review)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the review and redirects to the book' do
        patch :update, params: { book_id: book.id, id: review.id, review: { rating: 5, content: 'Amazing book!' } }
        review.reload
        expect(review.rating).to eq(5)
        expect(review.content).to eq('Amazing book!')
        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to eq('Review was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the review and renders the edit template' do
        patch :update, params: { book_id: book.id, id: review.id, review: { rating: nil, content: nil } }
        review.reload
        expect(review.rating).to eq(4)
        expect(review.content).to eq('Great book!')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested review and redirects to the book' do
      review_to_delete = book.reviews.create!(rating: 3, content: 'Not bad', user: user)
      expect {
        delete :destroy, params: { book_id: book.id, id: review_to_delete.id }
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to(book_path(book))
      expect(flash[:notice]).to eq('Review was successfully deleted.')
    end
  end

  describe 'Authorization' do
    context 'when the user is not the owner of the review' do
      let(:other_user) { User.create!(email: 'other@example.com', password: 'password') }
      let(:other_review) { book.reviews.create!(rating: 3, content: 'Not great', user: other_user) }

      it 'redirects to the book with an alert on edit' do
        sign_in other_user
        get :edit, params: { book_id: book.id, id: review.id }
        expect(response).to redirect_to(book_path(book))
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end

      it 'redirects to the book with an alert on update' do
        sign_in other_user
        patch :update, params: { book_id: book.id, id: review.id, review: { rating: 5, content: 'Updated content' } }
        expect(response).to redirect_to(book_path(book))
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end

      it 'redirects to the book with an alert on destroy' do
        sign_in other_user
        delete :destroy, params: { book_id: book.id, id: review.id }
        expect(response).to redirect_to(book_path(book))
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end
end
