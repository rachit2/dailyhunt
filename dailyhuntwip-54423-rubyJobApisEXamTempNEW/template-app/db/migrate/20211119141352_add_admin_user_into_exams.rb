class AddAdminUserIntoExams < ActiveRecord::Migration[6.0]
  def change
  	add_column :exams, :admin_user_id, :integer
  end
end
