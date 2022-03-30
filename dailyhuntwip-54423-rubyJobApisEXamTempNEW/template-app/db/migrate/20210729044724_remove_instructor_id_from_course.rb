class RemoveInstructorIdFromCourse < ActiveRecord::Migration[6.0]
  def change
    remove_reference :courses, :instructor
  end
end
