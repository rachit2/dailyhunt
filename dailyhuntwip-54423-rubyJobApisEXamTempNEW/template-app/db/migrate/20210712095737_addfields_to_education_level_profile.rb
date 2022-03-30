class AddfieldsToEducationLevelProfile < ActiveRecord::Migration[6.0]
  def change
    add_reference :education_level_profiles, :board
    add_reference :education_level_profiles, :standard
    add_column :education_level_profiles, :school_name, :string
  end
end
