class CreateBxBlockContentmanagementUserOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_options do |t|
      t.string :optionable_type
      t.integer :optionable_id
      t.references :test_question, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.integer :rank
      t.boolean :is_true

      t.timestamps
    end
  end
end
