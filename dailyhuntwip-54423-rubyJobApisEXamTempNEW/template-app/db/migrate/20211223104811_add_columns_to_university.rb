class AddColumnsToUniversity < ActiveRecord::Migration[6.0]
  def change
    add_column :universities, :median_salary, :float
    add_column :universities, :total_fees_min, :float
    add_column :universities, :total_fees_max, :float
    add_column :universities, :course_rating, :float
  end
end
