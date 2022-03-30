class AddSubcategoryIdInJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :sub_category_id, :integer
  end
end
