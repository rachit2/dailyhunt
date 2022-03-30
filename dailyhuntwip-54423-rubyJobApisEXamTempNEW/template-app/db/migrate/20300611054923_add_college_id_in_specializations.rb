class AddCollegeIdInSpecializations < ActiveRecord::Migration[6.0]
  def change
    add_column :specializations, :college_id, :integer
  end
end
