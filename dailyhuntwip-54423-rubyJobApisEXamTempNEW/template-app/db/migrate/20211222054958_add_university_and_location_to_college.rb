class AddUniversityAndLocationToCollege < ActiveRecord::Migration[6.0]
  def change
    add_reference :colleges, :university, foreign_key: true
    add_reference :colleges, :location, foreign_key: true
  end
end
