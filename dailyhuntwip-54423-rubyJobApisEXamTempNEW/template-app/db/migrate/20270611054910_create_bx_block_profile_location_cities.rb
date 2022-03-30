class CreateBxBlockProfileLocationCities < ActiveRecord::Migration[6.0]
  def change
    create_table :location_cities do |t|
      t.references :location, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
