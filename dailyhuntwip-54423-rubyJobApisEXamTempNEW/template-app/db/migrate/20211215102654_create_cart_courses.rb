class CreateCartCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_courses do |t|
      t.references :course_cart, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
