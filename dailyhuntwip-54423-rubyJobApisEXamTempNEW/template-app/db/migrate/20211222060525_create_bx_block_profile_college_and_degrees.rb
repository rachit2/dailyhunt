class CreateBxBlockProfileCollegeAndDegrees < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_profile_college_and_degrees do |t|
      t.references :college, null: false, foreign_key: true
      t.references :degree, null: false, foreign_key: true

      t.timestamps
    end
  end
end
