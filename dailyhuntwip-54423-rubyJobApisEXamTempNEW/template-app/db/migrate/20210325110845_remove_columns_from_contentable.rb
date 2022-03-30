class RemoveColumnsFromContentable < ActiveRecord::Migration[6.0]
  def up
    remove_column :audio_podcasts, :publishing_date_and_time
    remove_column :audio_podcasts, :tag
    remove_column :content_texts, :publishing_date_and_time
    remove_column :content_texts, :tags
    remove_column :content_videos, :publishing_date_and_time
    remove_column :content_videos, :tag
    remove_column :live_streams, :tag
    remove_column :live_streams, :scheduling_live_streaming
  end

  def down
    add_column :audio_podcasts, :publishing_date_and_time, :datetime
    add_column :audio_podcasts, :tag, :string
    add_column :content_texts, :publishing_date_and_time, :datetime
    add_column :content_texts, :tags, :string
    add_column :content_videos, :publishing_date_and_time, :datetime
    add_column :content_videos, :tag, :string
    add_column :live_streams, :tag, :string
    add_column :live_streams, :scheduling_live_streaming, :datetime
  end
end
