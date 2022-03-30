class CreateUserAssessments < ActiveRecord::Migration[6.0]
  def change
    create_table :user_assessments do |t|
      t.references :account, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true
      t.integer :tracker
      t.integer :rank

      t.timestamps
    end
  end
end
