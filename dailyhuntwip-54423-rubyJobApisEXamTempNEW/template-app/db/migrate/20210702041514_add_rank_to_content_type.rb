class AddRankToContentType < ActiveRecord::Migration[6.0]
  def change
    add_column :content_types, :rank, :integer
  end
end
