class AddRankInCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :rank, :integer
  end
end
