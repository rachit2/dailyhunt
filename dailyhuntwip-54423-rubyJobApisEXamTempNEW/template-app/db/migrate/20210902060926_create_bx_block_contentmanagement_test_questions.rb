class CreateBxBlockContentmanagementTestQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :test_questions do |t|
      t.string :question
      t.integer :options_number
      t.integer :questionable_id
      t.string :questionable_type

      t.timestamps
    end
  end
end
