class CreateBxBlockProfileCertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.string :certification_course_name
      t.string :provided_by
      t.integer :duration
      t.integer :completion_year
      t.integer :rank

      t.timestamps
    end
  end
end
