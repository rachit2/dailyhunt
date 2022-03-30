class CreateBxBlockProfileCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end
end
