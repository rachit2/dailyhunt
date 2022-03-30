class CreateBxBlockContentmanagementCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :heading
      t.text :description
      t.references :language
      t.bigint :content_provider_id, index: true
      t.integer :price
      t.references :instructor

      t.timestamps
    end
  end
end
