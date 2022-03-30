class AddPopularToExams < ActiveRecord::Migration[6.0]
  def change
    add_column :exams, :popular, :boolean
  end
end
