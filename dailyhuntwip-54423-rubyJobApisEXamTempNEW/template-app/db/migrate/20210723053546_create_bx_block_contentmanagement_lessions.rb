class CreateBxBlockContentmanagementLessions < ActiveRecord::Migration[6.0]
  def change
    create_table :lessions do |t|
      t.string :heading
      t.text :description
      t.integer :rank
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
