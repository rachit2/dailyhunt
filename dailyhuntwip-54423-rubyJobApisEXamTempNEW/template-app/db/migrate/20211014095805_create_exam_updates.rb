class CreateExamUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_updates do |t|
      t.date :date
      t.text :update_message
      t.string :link
      t.references :exam, foreign_key: true

      t.timestamps
    end
  end
end
