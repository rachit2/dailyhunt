class CreateCoursesLessionContents < ActiveRecord::Migration[6.0]
  def change
    create_table :courses_lession_contents do |t|
      t.integer :course_id
      t.integer :lessions_content_id
      t.integer :account_id
      t.timestamps
    end
  end
end
