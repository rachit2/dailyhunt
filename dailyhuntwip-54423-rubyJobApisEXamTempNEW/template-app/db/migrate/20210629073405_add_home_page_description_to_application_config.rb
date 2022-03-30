class AddHomePageDescriptionToApplicationConfig < ActiveRecord::Migration[6.0]
  def change
    add_column :application_configs, :home_page_description, :text
  end
end
