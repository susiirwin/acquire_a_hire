class AddSecretToUserApis < ActiveRecord::Migration[5.0]
  def change
    add_column :user_apis, :secret, :string
  end
end
