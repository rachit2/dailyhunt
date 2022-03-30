class AddIsPopularIsTrendingInQuestion < ActiveRecord::Migration[6.0]
  def change
  	add_column :questions, :is_popular, :boolean
  	add_column :questions, :is_trending, :boolean
  end
end
