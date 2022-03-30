class CreateBxBlockJobsAccountJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :account_jobs do |t|
      t.string :job_id
      t.string :company_id
      t.string :account_id
      t.timestamps
    end
  end
end
