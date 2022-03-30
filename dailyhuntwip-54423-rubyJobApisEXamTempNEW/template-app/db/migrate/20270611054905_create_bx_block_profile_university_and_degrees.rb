class CreateBxBlockProfileUniversityAndDegrees < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_profile_university_and_degrees do |t|
      t.references :university, null: false, foreign_key: true
      t.references :degree, null: false, foreign_key: true

      t.timestamps
    end
  end
end
