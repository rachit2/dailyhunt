class AddCityinAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :city, :string
  end
end
