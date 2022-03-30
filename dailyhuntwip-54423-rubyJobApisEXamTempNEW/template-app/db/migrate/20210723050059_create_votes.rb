class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :account
      t.references :question
      t.timestamps
    end
  end
end
