class AddOthersInCollege < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :is_others, :boolean, default: false
    add_column :profiles, :college_name, :string
    add_column :profiles, :competitive_exam_college_name, :string
    add_reference :education_level_profiles, :degree
    add_column :education_level_profiles, :educational_course_id, :integer
    add_reference :education_level_profiles, :college
    add_column :education_level_profiles, :passing_year, :string
    add_column :education_level_profiles, :college_name, :string
  end
end
