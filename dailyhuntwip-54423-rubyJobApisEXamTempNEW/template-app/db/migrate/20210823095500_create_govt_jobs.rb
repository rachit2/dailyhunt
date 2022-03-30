class CreateGovtJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :govt_jobs do |t|
      t.references :education_level, foreign_key: true
      t.references :specialization, foreign_key: true
      t.references :profile, foreign_key: true
      t.integer :caste_category

      t.timestamps
    end
  end
end
