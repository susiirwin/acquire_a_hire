class AddRevieweeRoleToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewee_role, :string
  end
end
