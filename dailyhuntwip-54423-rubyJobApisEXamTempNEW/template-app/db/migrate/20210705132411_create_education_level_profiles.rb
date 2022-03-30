class CreateEducationLevelProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :education_level_profiles do |t|
      t.references :education_level, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end

    add_column :education_levels, :level, :integer
  end
end
