class CreateBxBlockContentmanagementUserQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_quizzes do |t|
      t.references :account, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :tracker
      t.integer :rank

      t.timestamps
    end
  end
end
