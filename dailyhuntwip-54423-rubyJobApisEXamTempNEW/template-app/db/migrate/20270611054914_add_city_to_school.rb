class AddCityToSchool < ActiveRecord::Migration[6.0]
  def change
    add_reference :schools, :city, foreign_key: true
  end
end
