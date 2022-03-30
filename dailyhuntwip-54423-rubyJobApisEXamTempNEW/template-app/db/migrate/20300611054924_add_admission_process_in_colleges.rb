class AddAdmissionProcessInColleges < ActiveRecord::Migration[6.0]
  def change
    add_column :colleges, :admission_process, :integer
  end
end
