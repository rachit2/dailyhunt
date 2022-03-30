class AddDobInProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :dob, :date
    add_column :accounts, :gender, :integer
  end
end
