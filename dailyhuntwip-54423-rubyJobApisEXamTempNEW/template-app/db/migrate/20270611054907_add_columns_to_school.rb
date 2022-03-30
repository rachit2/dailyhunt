class AddColumnsToSchool < ActiveRecord::Migration[6.0]
  def change
    add_column :schools, :school_type, :integer
    add_column :schools, :language_of_interaction, :integer
    add_column :schools, :admission_process, :integer
  end
end
