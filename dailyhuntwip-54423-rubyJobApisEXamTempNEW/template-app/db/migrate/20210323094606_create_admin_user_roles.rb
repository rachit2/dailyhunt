class CreateAdminUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_user_roles do |t|
      t.references :admin_user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
