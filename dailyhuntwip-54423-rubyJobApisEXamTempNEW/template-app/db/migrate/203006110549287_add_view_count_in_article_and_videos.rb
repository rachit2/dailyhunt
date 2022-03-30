class AddViewCountInArticleAndVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :content_texts, :view_count, :bigint, default: 0
    add_column :content_videos, :view_count, :bigint, default: 0

  end
end
