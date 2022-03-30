class CreateBxBlockJobsJobPlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :job_places do |t|
        t.integer :job_location_id
        t.integer :job_id
      t.timestamps
    end
  end
end
