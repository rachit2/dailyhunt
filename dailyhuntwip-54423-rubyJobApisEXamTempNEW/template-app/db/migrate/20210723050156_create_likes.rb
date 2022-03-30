class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.bigint  :likeable_id
      t.string  :likeable_type
      t.boolean :is_like
      t.references :account
      t.timestamps
    end
  end
end
