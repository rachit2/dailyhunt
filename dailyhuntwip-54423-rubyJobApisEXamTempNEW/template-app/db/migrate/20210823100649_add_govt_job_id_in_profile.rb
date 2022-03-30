class AddGovtJobIdInProfile < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :caste_category
  end
end
