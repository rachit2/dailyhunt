class AddReviewStatusIntoContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :review_status, :integer
    add_column :contents, :feedback, :string
    add_column :contents, :admin_user_id, :integer
  end
end
