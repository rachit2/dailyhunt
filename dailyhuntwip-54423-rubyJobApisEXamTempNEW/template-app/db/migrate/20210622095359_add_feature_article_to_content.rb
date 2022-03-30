class AddFeatureArticleToContent < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :feature_article, :boolean
    add_column :contents, :feature_video, :boolean
  end
end
