class AddHeadlineIntoTests < ActiveRecord::Migration[6.0]
  def change
    add_column :tests, :headline, :string
  end
end
