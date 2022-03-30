class AddFieldsInProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :competitive_exam_standard_id, :bigint
    add_column :profiles, :competitive_exam_board_id, :bigint
    add_column :profiles, :competitive_exam_school_name, :string
    add_column :profiles, :competitive_exam_degree_id, :bigint
    add_column :profiles, :competitive_exam_specialization_id, :bigint
    add_column :profiles, :competitive_exam_course_id, :bigint
    add_column :profiles, :competitive_exam_college_id, :bigint
    add_column :profiles, :competitive_exam_passing_year, :string
  end
end
