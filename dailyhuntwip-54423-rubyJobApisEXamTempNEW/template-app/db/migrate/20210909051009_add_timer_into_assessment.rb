class AddTimerIntoAssessment < ActiveRecord::Migration[6.0]
  def change
    add_column :assessments, :timer, :string
  end
end
