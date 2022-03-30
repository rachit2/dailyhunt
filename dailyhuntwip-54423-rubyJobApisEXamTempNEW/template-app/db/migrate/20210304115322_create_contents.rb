class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.integer :sub_category_id
      t.integer :category_id
      t.integer :content_type_id
      t.integer :language_id
      t.references :contentable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
