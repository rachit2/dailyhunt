class CreateCategoriesPartners < ActiveRecord::Migration[6.0]
  def change
    create_table :categories_partners do |t|
      t.references :category, null: false, foreign_key: true
      t.references :partner, null: false, foreign_key: true
    end
  end
end
