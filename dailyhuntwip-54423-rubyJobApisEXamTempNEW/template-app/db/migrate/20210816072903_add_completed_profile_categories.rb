class AddCompletedProfileCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :completed_profile_categories, :string, array: true, default: []
  end
end
