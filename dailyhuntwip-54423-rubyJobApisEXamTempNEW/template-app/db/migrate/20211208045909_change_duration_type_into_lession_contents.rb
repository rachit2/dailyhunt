class ChangeDurationTypeIntoLessionContents < ActiveRecord::Migration[6.0]
  def change
    BxBlockContentmanagement::SetDurationNil.call
    change_column :lession_contents, :duration, 'integer USING CAST(duration AS integer)'
  end
end
