class AddLogoToCollege < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :logo, :string
  end
end
