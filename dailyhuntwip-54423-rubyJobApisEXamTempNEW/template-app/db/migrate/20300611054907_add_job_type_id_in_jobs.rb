class AddJobTypeIdInJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :job_type_id, :integer
  end
end
