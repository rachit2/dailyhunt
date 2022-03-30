class CreateBxBlockProfileSpecializationEducationLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :specialization_education_levels do |t|
      t.references :education_level
      t.references :specialization

      t.timestamps
    end
    remove_column :specializations, :higher_education_level_id
  end
end
