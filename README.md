## Overview
Book Review System is a Rails application that allows users to manage a collection of books and write reviews for them. This project prioritizes code quality, user-friendly experiences, and best practices in Rails development. The platform is ideal for demonstrating your expertise in building robust and interactive web applications.

## Core Features

## Authentication
User Management: Users can register, log in, and log out securely using Devise.
Guest Access: Anonymous users can browse books and reviews but cannot interact (e.g., add books or reviews).
Dynamic Navigation: Navigation options are dynamically updated based on the user's login state.   #

## Books Management
Create Books: Authenticated users can add new books with validations, including proper ISBN formatting.
Index View: Displays a paginated list of books, including search functionality by title or author.
Detail View: Shows detailed information about a book, including average ratings and associated reviews.

## Review System
CRUD Operations: Authenticated users can create, edit, and delete reviews for books.
Rating System: Users can rate books on a scale of 1-5 stars. HTML5 validation ensures ratings are within range.
Single Review Rule: A user can only review a book once.

## Technical Highlights
Framework & Language: Ruby on Rails
Database Management: ActiveRecord with proper relationships between Users, Books, and Reviews.
Pagination: Efficient handling of large book collections using Kaminari.
Validations: Comprehensive client- and server-side validations for books and reviews.
Search: Search functionality built with Ransack for finding books by title or author.
Error Handling: User-friendly error pages and inline validation error messages.
Flash Messages: Immediate feedback for user actions like form submissions.

# Instructions for Authentication

Signup and Login:
To start using the platform, first sign up for an account. After successful signup or login, you will be redirected to the Books Collection page at localhost:3000/books.

Searching for Books:
Use the search bar on the Books Collection page to find books by their title or author. Simply type your query, and the results will be filtered dynamically.

Viewing Book Details:
Click on any book title to view its detailed information, including the author, publication year, ISBN, average rating, and user reviews.

Writing Reviews:
Logged-in users can write a review for each book.
Once a review is created, the user can edit, update, or delete it at any time.
Adding New Books:

Only logged-in users can add new books to the collection.
If an unauthenticated user tries to add a book, they will be redirected to the login page with a prompt to authenticate first.

## Setup Instructions
# Follow these steps to run the project locally:

# Prerequisites
Ruby on Rails
SQLite3 (configured in config/database.yml)
Node.js and Yarn for managing frontend dependencies.

# Install Dependencies
bundle install
yarn install

# Setup Database
rails db:create
rails db:migrate
rails db:seed

# Run the Application
rails server

# Visit the Application
Open your browser and navigate to http://localhost:3000.

# Testing
Run model and controller tests with RSpec:

# Key Libraries & Tools Used
Devise: For user authentication.
Ransack: For search functionality.
Kaminari: For pagination.
RSpec: For testing.