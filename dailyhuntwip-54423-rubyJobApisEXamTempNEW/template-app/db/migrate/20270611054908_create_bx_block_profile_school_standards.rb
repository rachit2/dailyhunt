class CreateBxBlockProfileSchoolStandards < ActiveRecord::Migration[6.0]
  def change
    create_table :school_standards do |t|
      t.references :school, null: false, foreign_key: true
      t.references :standard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
