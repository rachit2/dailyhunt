class CreateBxBlockExpertsArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.string :image
      t.integer :career_expert_id
      t.integer :category_id
      t.integer :view, default: 0
      t.integer :status
      t.datetime :publish_date
      t.timestamps
    end
  end
end
