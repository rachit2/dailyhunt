class AddBookmarkableInBookmark < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :bookmarkable_id, :bigint
    add_column :bookmarks, :bookmarkable_type, :string
    remove_column :bookmarks, :content_id 
  end
end
