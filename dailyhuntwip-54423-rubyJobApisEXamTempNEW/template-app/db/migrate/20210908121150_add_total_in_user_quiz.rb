class AddTotalInUserQuiz < ActiveRecord::Migration[6.0]
  def change
    add_column :user_quizzes, :total, :integer
  end
end
