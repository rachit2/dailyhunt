class CreateTotalFees < ActiveRecord::Migration[6.0]
  def change
    create_table :total_fees do |t|
      t.bigint :min
      t.bigint :max
      t.boolean :is_active
      t.timestamps
    end
  end
end
