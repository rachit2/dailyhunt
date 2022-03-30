class CreateContentTypesPartners < ActiveRecord::Migration[6.0]
  def change
    create_table :content_types_partners do |t|
      t.references :content_type, null: false, foreign_key: true
      t.references :partner, null: false, foreign_key: true
    end
  end
end
