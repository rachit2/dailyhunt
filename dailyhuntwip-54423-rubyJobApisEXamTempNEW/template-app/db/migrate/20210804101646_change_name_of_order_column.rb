class ChangeNameOfOrderColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :order_courses, :order_id, :course_order_id
  end
end
