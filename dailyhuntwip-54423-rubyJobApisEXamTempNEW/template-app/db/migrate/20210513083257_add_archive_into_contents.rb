class AddArchiveIntoContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :archived, :boolean, default: false 
  end
end
