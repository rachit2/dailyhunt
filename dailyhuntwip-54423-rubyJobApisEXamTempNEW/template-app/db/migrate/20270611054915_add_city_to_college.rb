class AddCityToCollege < ActiveRecord::Migration[6.0]
  def change
    add_reference :colleges, :city, foreign_key: true
  end
end
