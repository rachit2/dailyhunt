class AddCollegeTypeInColleges < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :college_type, :integer
  end
end
