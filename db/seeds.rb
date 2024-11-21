# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create test users
users = []
5.times do |i|
  users << User.create!(
    email: "user#{i+1}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )
end

# Create sample books
books = []
20.times do |i|
  books << Book.create!(
    title: "Book Title #{i+1}",
    author: "Author #{i+1}",
    publication_year: rand(1990..2024),
    isbn: "978-#{rand(1000000000..9999999999)}"
  )
end

# Create reviews
books.each do |book|
  # Each book gets 0-3 random reviews
  users.sample(rand(0..3)).each do |user|
    Review.create!(
      user: user,
      book: book,
      rating: rand(1..5),
      content: "This is a sample review for #{book.title}. #{['Great book!', 'Interesting read.', 'Could be better.', 'Highly recommended!'].sample}"
    )
  end
end

puts "Seed data created successfully!"
puts "Created #{User.count} users"
puts "Created #{Book.count} books"
puts "Created #{Review.count} reviews"
