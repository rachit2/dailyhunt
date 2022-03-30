class RenameLiveStreamCommentSection < ActiveRecord::Migration[6.0]
  def change
    rename_column :live_streams, :comment_section, :url
  end
end
