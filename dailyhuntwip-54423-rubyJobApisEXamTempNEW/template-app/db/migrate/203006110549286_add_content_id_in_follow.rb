class AddContentIdInFollow < ActiveRecord::Migration[6.0]
  def change
    add_reference :follows, :content_video, foreign_key: true
    add_reference :follows, :content_text, foreign_key: true

  end
end
