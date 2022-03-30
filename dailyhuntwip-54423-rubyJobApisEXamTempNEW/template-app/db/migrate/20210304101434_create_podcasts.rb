class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :audio_podcasts do |t|
      t.string :heading
      t.string :description
      t.string :tag
      t.datetime :publishing_date_and_time
      t.timestamps
    end
  end
end
