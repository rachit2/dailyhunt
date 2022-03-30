class AddIsArticleAndIsVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :banners, :is_article, :boolean
    add_column :banners, :is_video, :boolean
  end
end
