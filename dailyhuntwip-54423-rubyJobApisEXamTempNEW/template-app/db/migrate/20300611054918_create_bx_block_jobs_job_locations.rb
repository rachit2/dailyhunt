class CreateBxBlockJobsJobLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :job_locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :state
      t.string :country
      t.string :address
      t.timestamps
    end
  end
end
