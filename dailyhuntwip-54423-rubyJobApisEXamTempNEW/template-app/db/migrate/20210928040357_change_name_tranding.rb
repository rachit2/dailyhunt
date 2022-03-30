class ChangeNameTranding < ActiveRecord::Migration[6.0]
  def change
    rename_column :courses, :is_tranding, :is_trending
  end
end
