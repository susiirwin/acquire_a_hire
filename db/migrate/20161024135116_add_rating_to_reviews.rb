class AddRatingToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :rating, :string
  end
end
