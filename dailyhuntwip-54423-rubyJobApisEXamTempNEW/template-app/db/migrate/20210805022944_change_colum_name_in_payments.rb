class ChangeColumNameInPayments < ActiveRecord::Migration[6.0]
  def change
    rename_column :payments, :order_id, :course_order_id
  end
end
