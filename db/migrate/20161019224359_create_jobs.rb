class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.references :skill, foreign_key: true
      t.integer :min_price
      t.integer :max_price
      t.references :requester, references: :users
      t.string :status
      t.string :description

      t.timestamps
    end
  end
end
