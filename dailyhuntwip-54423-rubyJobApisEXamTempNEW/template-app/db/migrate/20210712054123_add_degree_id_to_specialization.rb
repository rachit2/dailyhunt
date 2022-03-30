class AddDegreeIdToSpecialization < ActiveRecord::Migration[6.0]
  def change
    add_column :specializations, :degree_id, :bigint, index: true, foreign_key: true
  end
end
