class AddAuthorizedToUserAuthorization < ActiveRecord::Migration[5.0]
  def change
    add_column :user_authorizations, :authorized, :boolean, default: false
  end
end
