class AddEmailVerifiedInUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :email_verified, :boolean
  	add_column :accounts, :phone_verified, :boolean
  end
end
