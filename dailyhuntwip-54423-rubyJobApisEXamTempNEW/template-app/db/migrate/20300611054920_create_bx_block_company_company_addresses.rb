class CreateBxBlockCompanyCompanyAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :company_addresses do |t|
      t.string :address
      t.integer :company_id
      t.timestamps
    end
  end
end
