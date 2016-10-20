class AddForeignKeyToJobs < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :jobs, :users, column: :requester_id
  end
end
