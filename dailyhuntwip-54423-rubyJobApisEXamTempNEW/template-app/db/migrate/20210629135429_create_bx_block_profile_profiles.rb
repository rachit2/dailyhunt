class CreateBxBlockProfileProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.references :account
      t.integer :caste_category
      t.references :board, foreign_key: true
      t.string :school_name
      t.references :standard, foreign_key: true
      t.references :degree, foreign_key: true
      t.references :specialization, foreign_key: true
      t.references :course, foreign_key: true
      t.references :college, foreign_key: true
      t.integer :passing_year
      
      t.timestamps
    end
  end
end
