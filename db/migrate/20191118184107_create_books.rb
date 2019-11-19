class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :description
      t.string :author_name
      t.string :book_from
      t.string :book_to
      t.string :comment
      t.integer :status

      t.timestamps
    end
  end
end
