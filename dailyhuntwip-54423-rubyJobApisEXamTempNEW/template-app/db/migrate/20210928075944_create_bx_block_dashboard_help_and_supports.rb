class CreateBxBlockDashboardHelpAndSupports < ActiveRecord::Migration[6.0]
  def change
    create_table :help_and_supports do |t|
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
