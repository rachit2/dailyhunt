class CreateBxBlockContentmanagementExamSections < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_sections do |t|
      t.string :title
      t.text :body
      t.references :exam, null: false, foreign_key: true

      t.timestamps
    end
  end
end
