class CreateBxBlockProfileExamSubjectProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_subject_profiles do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
