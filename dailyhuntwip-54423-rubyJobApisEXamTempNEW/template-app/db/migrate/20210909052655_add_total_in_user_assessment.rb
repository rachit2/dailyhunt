class AddTotalInUserAssessment < ActiveRecord::Migration[6.0]
  def change
    add_column :user_assessments, :total, :integer
  end
end
