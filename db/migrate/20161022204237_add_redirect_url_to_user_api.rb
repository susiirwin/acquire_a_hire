class AddRedirectUrlToUserApi < ActiveRecord::Migration[5.0]
  def change
    add_column :user_apis, :redirect_url, :string
  end
end
