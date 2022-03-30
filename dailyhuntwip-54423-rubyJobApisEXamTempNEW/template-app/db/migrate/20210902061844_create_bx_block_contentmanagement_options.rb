class CreateBxBlockContentmanagementOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.string :answer
      t.text :description
      t.boolean :is_right
      t.references :test_question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
