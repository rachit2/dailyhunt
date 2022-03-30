class ChangeDefaultInCourse < ActiveRecord::Migration[6.0]
  def change
    change_column_default :lession_contents, :is_free, false
  end
end
