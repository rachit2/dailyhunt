class AddColumnsToCollege < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :is_popular, :boolean, default: false
    add_column :colleges, :is_featured, :boolean, default: false
    add_column :colleges, :total_fees_min, :float
    add_column :colleges, :total_fees_max, :float
    add_column :colleges, :median_salary, :float
    add_column :colleges, :course_rating, :float
    add_column :colleges, :website_url, :string
  end
end
