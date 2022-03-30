class AddLogoInTheLocationAndCity < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :logo, :string
    add_column :cities, :logo, :string
  end
end
