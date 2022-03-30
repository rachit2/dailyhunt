class AddTimerInQuiz < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :timer, :string
  end
end
