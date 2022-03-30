class CreatePartners < ActiveRecord::Migration[6.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :spoc_name
      t.string :spoc_contact
      t.text :address
      t.integer :partner_type
      t.integer :partnership_type
      t.float :partner_margins_per
      t.boolean :includes_gst
      t.float :tax_margins
      t.integer :status
      t.boolean :created_by_admin, default: true
      t.references :admin_user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
