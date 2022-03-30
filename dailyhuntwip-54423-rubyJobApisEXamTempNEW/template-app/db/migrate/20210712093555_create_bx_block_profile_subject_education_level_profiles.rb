class CreateBxBlockProfileSubjectEducationLevelProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :subject_education_levels do |t|
      t.bigint :education_level_profile_id, index: true
      t.bigint :subject_id, index: true, foreign_key: true

      t.timestamps
    end
  end
end
