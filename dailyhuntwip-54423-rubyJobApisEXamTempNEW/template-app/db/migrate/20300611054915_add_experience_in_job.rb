class AddExperienceInJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :experience, :integer
  end
end
