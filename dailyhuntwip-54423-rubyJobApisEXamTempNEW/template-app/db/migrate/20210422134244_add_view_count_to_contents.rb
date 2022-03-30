class AddViewCountToContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :view_count, :bigint, default: 0
  end
end
