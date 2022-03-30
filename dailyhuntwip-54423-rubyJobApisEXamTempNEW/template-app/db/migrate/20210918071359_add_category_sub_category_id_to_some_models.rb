class AddCategorySubCategoryIdToSomeModels < ActiveRecord::Migration[6.0]
  def change
    add_reference :exams, :category
    add_reference :exams, :sub_category
    add_reference :quizzes, :category
    add_reference :quizzes, :sub_category
    add_reference :assessments, :category
    add_reference :assessments, :sub_category
    add_reference :courses, :category
    add_reference :courses, :sub_category
  end
end
