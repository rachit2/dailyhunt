class CreateBxBlockProfileEducationLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :education_levels do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end
end
