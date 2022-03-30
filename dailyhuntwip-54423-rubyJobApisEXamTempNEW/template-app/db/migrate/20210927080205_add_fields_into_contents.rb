class AddFieldsIntoContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :crm_type, :integer, index: true
    add_column :contents, :crm_id, :integer, index: true
    add_column :contents, :detail_url, :string
  end
end
