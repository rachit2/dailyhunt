class AddFieldsInPartners < ActiveRecord::Migration[6.0]
  def change
    add_column :partners, :bank_ifsc, :string
    add_column :partners, :account_number, :bigint
    add_column :partners, :account_name, :string
    add_column :partners, :bank_name, :string
  end
end
