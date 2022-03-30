class AddAvailableFreeTrailInCourse < ActiveRecord::Migration[6.0]
  def change
  	add_column :courses, :available_free_trail, :boolean
  end
end
