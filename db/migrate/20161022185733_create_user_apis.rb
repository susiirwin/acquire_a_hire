class CreateUserApis < ActiveRecord::Migration[5.0]
  def change
    create_table :user_apis do |t|
      t.integer :uid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :description
      t.string :url
      t.string :key

      t.timestamps
    end
  end
end
