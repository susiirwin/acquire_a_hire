class AddUserToUserApi < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_apis, :uid
    add_reference :user_apis, :user, foreign_key: true
  end
end
