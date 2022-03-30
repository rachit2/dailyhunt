class AddLogoInJobCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :job_categories, :logo, :string
  end
end
