class CreateBxBlockContentmanagementLessionContents < ActiveRecord::Migration[6.0]
  def change
    create_table :lession_contents do |t|
      t.string :heading
      t.text :description
      t.integer :rank
      t.integer :content_type 
      t.time :duration
      t.references :lession, null: false, foreign_key: true

      t.timestamps
    end
  end
end
