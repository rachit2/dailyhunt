class AddAttemptCountIntoUserAssessmentAndUserQuiz < ActiveRecord::Migration[6.0]
  def up
    add_column :user_quizzes, :attempt_count, :integer
    add_column :user_assessments, :attempt_count, :integer
  end

  def down
    remove_column :user_quizzes, :attempt_count, :integer
    remove_column :user_assessments, :attempt_count, :integer
  end
end
