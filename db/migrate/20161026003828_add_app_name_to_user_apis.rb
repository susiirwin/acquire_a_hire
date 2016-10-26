class AddAppNameToUserApis < ActiveRecord::Migration[5.0]
  def change
    add_column :user_apis, :app_name, :string
  end
end
