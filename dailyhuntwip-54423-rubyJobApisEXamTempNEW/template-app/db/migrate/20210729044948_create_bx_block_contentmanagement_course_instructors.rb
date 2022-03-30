class CreateBxBlockContentmanagementCourseInstructors < ActiveRecord::Migration[6.0]
  def change
    create_table :course_instructors do |t|
      t.references :course, foreign_key: true
      t.references :instructor, foreign_key: true

      t.timestamps
    end
  end
end
