class CreateBxBlockProfileUniversities < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_profile_universities do |t|
      t.string :name
      t.boolean :is_featured
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
