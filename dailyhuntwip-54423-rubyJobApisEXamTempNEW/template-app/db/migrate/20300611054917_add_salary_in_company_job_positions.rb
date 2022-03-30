class AddSalaryInCompanyJobPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :company_job_positions, :salary, :bigint
  end
end
