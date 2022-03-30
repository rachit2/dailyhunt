class AddColumnToCity < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :address, :string
  end
end
