class RenameExamAdminUserToContentProvider < ActiveRecord::Migration[6.0]
  def change
  	rename_column :exams, :admin_user_id, :content_provider_id
  end
end
