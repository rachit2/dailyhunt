class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :description
      t.references :account
      t.references :sub_category
      t.integer :view, default: 0
      t.integer :status
      t.boolean :closed
      t.string :image
      t.timestamps
    end
  end
end