class CreateBxBlockProfileBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end
end
