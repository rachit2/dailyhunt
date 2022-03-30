class CreateTexts < ActiveRecord::Migration[6.0]
  def change
    create_table :content_texts do |t|
      t.string :headline
      t.string :content
      t.string :tags
      t.datetime :publishing_date_and_time
      t.string :hyperlink
      t.string :affiliation
      t.timestamps
    end
  end
end
