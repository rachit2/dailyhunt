class CreateBxBlockDashboardFaqs < ActiveRecord::Migration[6.0]
  def change
    create_table :faqs do |t|
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
