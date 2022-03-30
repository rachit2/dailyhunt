class CreateBxBlockProfileSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end
end
