class ChangeOrderTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :orders, :course_orders
  end
end
