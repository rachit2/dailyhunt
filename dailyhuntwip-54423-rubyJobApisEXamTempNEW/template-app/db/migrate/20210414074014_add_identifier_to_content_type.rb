class AddIdentifierToContentType < ActiveRecord::Migration[6.0]
  def change
    add_column :content_types, :identifier, :integer
  end
end
