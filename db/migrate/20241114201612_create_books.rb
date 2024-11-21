class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.integer :publication_year, null: false
      t.string :isbn, null: false
      t.decimal :average_rating, precision: 3, scale: 2

      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :title
    add_index :books, :author
  end
end