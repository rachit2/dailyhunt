class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :status
      t.references :account, null: false, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
