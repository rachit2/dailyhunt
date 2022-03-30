class CreateBxBlockJobsCompanyJobPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :company_job_positions do |t|
      t.integer :company_id
      t.integer :job_id
      t.boolean :is_vacant
      t.string :employment_type

      t.timestamps
    end
  end
end
