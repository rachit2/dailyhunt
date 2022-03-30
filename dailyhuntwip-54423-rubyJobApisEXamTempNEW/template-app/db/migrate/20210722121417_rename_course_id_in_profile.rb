class RenameCourseIdInProfile < ActiveRecord::Migration[6.0]
  def change
    rename_column :profiles, :course_id, :educational_course_id
  end
end
