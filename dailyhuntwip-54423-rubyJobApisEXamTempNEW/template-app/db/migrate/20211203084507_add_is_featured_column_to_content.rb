class AddIsFeaturedColumnToContent < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :is_featured, :boolean
  end
end
