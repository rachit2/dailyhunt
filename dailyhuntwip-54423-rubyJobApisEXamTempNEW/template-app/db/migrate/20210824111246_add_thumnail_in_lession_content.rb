class AddThumnailInLessionContent < ActiveRecord::Migration[6.0]
  def change
    add_column :lession_contents, :thumbnail, :string
  end
end
