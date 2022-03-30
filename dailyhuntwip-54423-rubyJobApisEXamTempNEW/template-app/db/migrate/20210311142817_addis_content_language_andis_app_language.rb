class AddisContentLanguageAndisAppLanguage < ActiveRecord::Migration[6.0]
  def change
    add_column :languages, :is_content_language, :boolean
    add_column :languages, :is_app_language, :boolean
  end
end
