class AddHighestEducationLevelInSpecialization < ActiveRecord::Migration[6.0]
  def change
    add_column :specializations, :higher_education_level_id, :bigint
  end
end
