class AddDescriptionInQuiz < ActiveRecord::Migration[6.0]
  def change
  	add_column :quizzes, :quiz_description, :text
  end
end
