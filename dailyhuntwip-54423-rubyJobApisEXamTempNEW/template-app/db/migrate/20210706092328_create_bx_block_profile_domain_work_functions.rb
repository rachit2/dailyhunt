class CreateBxBlockProfileDomainWorkFunctions < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_work_functions do |t|
      t.string :name 
      t.integer :rank

      t.timestamps
    end

    add_column :employment_details, :domain_work_function_id, :bigint
  end
end
