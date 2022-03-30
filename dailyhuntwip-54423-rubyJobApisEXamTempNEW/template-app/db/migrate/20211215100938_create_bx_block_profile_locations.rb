class CreateBxBlockProfileLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.boolean :is_top_location, default: false

      t.timestamps
    end
  end
end
