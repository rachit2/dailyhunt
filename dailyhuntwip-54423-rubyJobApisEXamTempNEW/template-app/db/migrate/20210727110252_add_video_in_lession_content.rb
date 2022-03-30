class AddVideoInLessionContent < ActiveRecord::Migration[6.0]
  def change
    add_column :lession_contents, :video, :string
    add_column :lession_contents, :file_content, :string
  end
end
