class AddStatusAndPublishDateIntoContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :status, :integer
    add_column :contents, :publish_date, :datetime
  end
end
