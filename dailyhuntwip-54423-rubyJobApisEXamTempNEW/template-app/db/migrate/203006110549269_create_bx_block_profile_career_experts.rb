class CreateBxBlockProfileCareerExperts < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experts do |t|
      t.string :name
      t.string :description
      t.string :designation
      t.string :status
      t.decimal :price
      t.timestamps
    end
  end
end
