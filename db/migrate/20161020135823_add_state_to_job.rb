class AddStateToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :state, :string
  end
end
