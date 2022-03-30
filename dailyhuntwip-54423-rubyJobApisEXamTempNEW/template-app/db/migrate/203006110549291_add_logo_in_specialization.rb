class AddLogoInSpecialization < ActiveRecord::Migration[6.0]
  def change
    add_column :specializations, :logo, :string
  end
end
