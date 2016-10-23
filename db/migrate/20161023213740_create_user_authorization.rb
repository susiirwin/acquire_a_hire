class CreateUserAuthorization < ActiveRecord::Migration[5.0]
  def change
    create_table :user_authorizations do |t|
      t.string :code
      t.references :user, foreign_key: true
      t.references :user_api, foreign_key: true
    end
  end
end
