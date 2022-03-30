class AddIsTrendingAndIsPopularIntoEpubs < ActiveRecord::Migration[6.0]
  def change
    add_column :epubs, :is_popular, :boolean
    add_column :epubs, :is_trending, :boolean
  end
end
