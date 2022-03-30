class AddthumbnailInExam < ActiveRecord::Migration[6.0]
  def change
    add_column :exams, :thumbnail, :string
  end
end
