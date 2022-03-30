class AddIsTrendingIsPoplarInAudioPodcast < ActiveRecord::Migration[6.0]
  def change
    add_column :audio_podcasts, :is_popular, :boolean
    add_column :audio_podcasts, :is_trending, :boolean
  end
end
