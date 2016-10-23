class AddProfessionalToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :professional
  end
end
