class RemoveIsTrendingFromAudioPodcast < ActiveRecord::Migration[6.0]
  def change
    remove_column :audio_podcasts, :is_popular
    remove_column :audio_podcasts, :is_trending
    remove_column :epubs, :is_popular
    remove_column :epubs, :is_trending
  end
end
