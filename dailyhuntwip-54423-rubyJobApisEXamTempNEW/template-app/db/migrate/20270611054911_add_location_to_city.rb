class AddLocationToCity < ActiveRecord::Migration[6.0]
  def change
    add_reference :cities, :location, null: false, foreign_key: true
  end
end
