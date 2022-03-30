class CreateCourseCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :course_carts do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
