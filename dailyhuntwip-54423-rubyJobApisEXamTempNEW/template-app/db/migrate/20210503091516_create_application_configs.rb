class CreateApplicationConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :application_configs do |t|
      t.string :mime_type
      t.integer :status
      t.timestamps
    end
  end
end
