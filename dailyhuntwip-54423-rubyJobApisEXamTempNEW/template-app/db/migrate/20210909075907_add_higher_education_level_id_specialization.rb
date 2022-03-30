class AddHigherEducationLevelIdSpecialization < ActiveRecord::Migration[6.0]
  def change
    add_column :specializations, :higher_education_level_id, :bigint, foreign_key: true, index: true
  end
end
