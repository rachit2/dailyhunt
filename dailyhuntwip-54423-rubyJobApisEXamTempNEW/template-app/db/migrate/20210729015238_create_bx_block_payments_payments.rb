class CreateBxBlockPaymentsPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
