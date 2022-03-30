class RenameFromAndToInExams < ActiveRecord::Migration[6.0]

  def up
    rename_column :exams, :from, :start_date
    rename_column :exams, :to, :end_date
  end

  def down
    rename_column :exams, :start_date, :from
    rename_column :exams, :end_date, :to
  end

end
