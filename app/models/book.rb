class Book < ApplicationRecord
    has_many :reviews, dependent: :destroy
    has_many :reviewers, through: :reviews, source: :user

    validates :title, presence: true
    validates :author, presence: true
    validates :publication_year, presence: true, 
                numericality: { only_integer: true, 
                            greater_than: 1800, 
                            less_than_or_equal_to: Time.current.year }
    validates :isbn, presence: true, 
                format: { 
                with: /\A(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+$\z/,
                message: "must be a valid ISBN-10 or ISBN-13"
                }
                
    scope :with_reviews, -> { includes(:reviews) }

    def update_average_rating
        update_column(
        :average_rating, 
        reviews.average(:rating)
        )
    end

    def reviewed_by?(user)
        reviews.exists?(user: user)
    end

    def self.ransackable_attributes(auth_object = nil)
        ["author", "average_rating", "created_at", "id", "isbn", "publication_year", "title", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["reviewers", "reviews"]
    end
end
  