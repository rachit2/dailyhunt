class CreateBxBlockProfileEmploymentDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :employment_details do |t|
      t.string :last_employer
      t.string :designation
      t.integer :rank

      t.timestamps
    end
  end
end
