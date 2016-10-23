class AddProfessionalForeignKeyToJobs < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :jobs, :users, column: :professional_id
  end
end
