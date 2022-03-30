class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text    :description
      t.bigint  :commentable_id
      t.string  :commentable_type
      t.references :account
      t.timestamps
    end
  end
end
