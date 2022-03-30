class AddEducationLevelIdInProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :higher_education_level_id, :bigint
  end
end
