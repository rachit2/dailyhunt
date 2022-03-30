class CreateBxBlockContentmanagementRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.string :review 
      t.references :account
      t.references :reviewable, polymorphic: true

      t.timestamps
    end
  end
end
