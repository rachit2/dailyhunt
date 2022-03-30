class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :title
      t.text :description
      t.references :account
      t.references :question
      t.timestamps
    end
  end
end
