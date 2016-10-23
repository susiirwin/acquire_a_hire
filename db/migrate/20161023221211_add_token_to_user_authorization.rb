class AddTokenToUserAuthorization < ActiveRecord::Migration[5.0]
  def change
    add_column :user_authorizations, :token, :string
  end
end
