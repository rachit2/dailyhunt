class AddExamIdToContentVideo < ActiveRecord::Migration[6.0]
  def change
    add_reference :content_videos, :exam, foreign_key: true
  end
end
