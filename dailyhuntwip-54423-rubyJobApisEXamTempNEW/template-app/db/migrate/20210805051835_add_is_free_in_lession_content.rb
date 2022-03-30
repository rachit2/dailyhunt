class AddIsFreeInLessionContent < ActiveRecord::Migration[6.0]
  def change
    add_column :lession_contents, :is_free, :boolean, default: true
  end
end
