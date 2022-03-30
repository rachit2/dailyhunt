class CreateBxBlockProfileSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.boolean :is_featured
      t.boolean :is_popular
      t.float :total_fees_min
      t.float :total_fees_max
      t.float :median_salary
      t.float :course_rating
      t.integer :rank
      t.string :website_url
      t.string :logo
      t.references :location, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
