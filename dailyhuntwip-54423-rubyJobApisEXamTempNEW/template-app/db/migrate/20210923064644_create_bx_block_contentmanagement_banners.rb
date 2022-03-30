class CreateBxBlockContentmanagementBanners < ActiveRecord::Migration[6.0]
  def change
    create_table :banners do |t|
      t.integer :status
      t.boolean :is_explore
      t.integer :rank
      t.datetime :start_time
      t.datetime :end_time
      t.string :bannerable_type
      t.integer :bannerable_id
      t.string :image

      t.timestamps
    end
  end
end
