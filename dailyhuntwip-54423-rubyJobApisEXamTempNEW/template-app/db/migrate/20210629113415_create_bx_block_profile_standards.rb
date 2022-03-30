class CreateBxBlockProfileStandards < ActiveRecord::Migration[6.0]
  def change
    create_table :standards do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end
end
