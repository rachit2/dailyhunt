class AddSearchableTextToContent < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :searchable_text, :string 
  end
end
