class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  
  validates :rating, presence: true, 
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5
            }
  validates :content, presence: true, 
            length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { 
    scope: :book_id,
    message: "has already reviewed this book"
  }
  
  after_save :update_book_average_rating
  after_destroy :update_book_average_rating
  
  private
  
  def update_book_average_rating
    book.update_average_rating
  end
end