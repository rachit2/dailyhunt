class AddExamIdInAssessment < ActiveRecord::Migration[6.0]
  def change
    add_reference :assessments, :exam, foreign_key: true
  end
end
