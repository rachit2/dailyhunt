class ChangeDurationTypeInLessionContent < ActiveRecord::Migration[6.0]
  def change
    change_column :lession_contents, :duration, :string
  end
end
