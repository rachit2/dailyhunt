class AddDesignationInInstructor < ActiveRecord::Migration[6.0]
  def change
    add_column :instructors, :designation, :string
  end
end
