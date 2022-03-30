class AddLogoToUniversity < ActiveRecord::Migration[6.0]
  def change
    add_column :universities, :logo, :string
  end
end
