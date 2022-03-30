class CreateJoinTableCollegeCourses < ActiveRecord::Migration[6.0]
  def change
    create_join_table :colleges, :courses do |t|
      # t.index [:college_id, :course_id]
      # t.index [:course_id, :college_id]
    end
  end
end
