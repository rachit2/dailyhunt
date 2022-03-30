class AddSubCategoryIdInColleges < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :sub_category_id, :integer
  end
end
