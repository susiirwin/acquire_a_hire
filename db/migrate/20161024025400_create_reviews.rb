class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.text :review
      t.integer :professional_id, null: false
      t.integer :requester_id, null: false
      t.timestamps
    end
    add_foreign_key :reviews, :users, column: :professional_id
    add_foreign_key :reviews, :users, column: :requester_id
  end
end
