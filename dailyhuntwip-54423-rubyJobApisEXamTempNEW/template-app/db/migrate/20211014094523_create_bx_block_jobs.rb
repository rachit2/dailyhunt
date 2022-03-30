class CreateBxBlockJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.text :requirement
      t.integer :job_type

      t.timestamps
    end
  end
end
