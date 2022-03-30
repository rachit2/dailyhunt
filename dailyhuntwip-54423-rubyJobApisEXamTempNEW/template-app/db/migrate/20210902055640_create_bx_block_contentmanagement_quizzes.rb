class CreateBxBlockContentmanagementQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.string :heading
      t.text :description
      t.references :language, null: false, foreign_key: true
      t.integer :content_provider_id
      t.boolean :is_popular
      t.boolean :is_trending

      t.timestamps
    end
  end
end
