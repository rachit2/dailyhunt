class CreatePdfs < ActiveRecord::Migration[6.0]
  def change
    create_table :pdfs do |t|
      t.integer :attached_item_id, index: true
      t.string :attached_item_type, index: true
      t.string :pdf

      t.timestamps
    end
  end
end
