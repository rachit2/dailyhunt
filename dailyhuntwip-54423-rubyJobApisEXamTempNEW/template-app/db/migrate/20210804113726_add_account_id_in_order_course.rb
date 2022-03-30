class AddAccountIdInOrderCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :order_courses, :account_id, :bigint
  end
end
