class CreatePartnersSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :partners_sub_categories do |t|
      t.references :partner, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
    end
  end
end
