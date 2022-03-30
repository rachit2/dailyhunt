class AddCareerExpertIdInTextBlogVideo < ActiveRecord::Migration[6.0]
  def change
    add_reference :content_videos, :career_expert, foreign_key: true
    add_reference :content_texts, :career_expert, foreign_key: true

  end
end
