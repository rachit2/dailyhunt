class CreateLoginBackgroundFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :login_background_files do |t|
      t.integer :attached_item_id, index: true
      t.string :attached_item_type, index: true
      t.string :login_background_file

      t.timestamps
    end
  end
end
