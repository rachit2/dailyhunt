class AddJobCategoryIdInJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :job_category_id, :integer
  end
end
