class ChangeCourseName < ActiveRecord::Migration[6.0]
  def change
    rename_table :courses, :educational_courses
  end
end
