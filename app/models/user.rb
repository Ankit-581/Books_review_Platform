class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :reviews, dependent: :destroy
  has_many :reviewed_books, through: :reviews, source: :book
  
  validates :email, presence: true, uniqueness: true
end
