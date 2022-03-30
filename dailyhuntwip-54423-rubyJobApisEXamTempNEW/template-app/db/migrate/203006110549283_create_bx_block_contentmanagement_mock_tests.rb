class CreateBxBlockContentmanagementMockTests < ActiveRecord::Migration[6.0]
  def change
    create_table :mock_tests do |t|
      t.string :description
      t.integer :exam_id
      t.string :heading
      t.string :pdf
      t.timestamps
    end
  end
end
