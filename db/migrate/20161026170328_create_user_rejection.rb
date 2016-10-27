class CreateUserRejection < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rejections do |t|
      t.references :job, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :rejected, default: true
    end
  end
end
