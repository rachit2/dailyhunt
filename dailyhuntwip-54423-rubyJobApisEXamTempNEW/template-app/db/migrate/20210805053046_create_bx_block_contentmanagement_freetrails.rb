class CreateBxBlockContentmanagementFreetrails < ActiveRecord::Migration[6.0]
  def change
    create_table :freetrails do |t|
      t.references :account
      t.references :course

      t.timestamps
    end
  end
end
