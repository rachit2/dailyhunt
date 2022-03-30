class AddIsPopularInContent < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :is_popular, :boolean
    add_column :contents, :is_trending, :boolean
  end
end
