class AddSpecializationIdInEducationLevelProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :education_level_profiles, :specialization_id, :bigint, foreign_key: true, index: true
  end
end
