class AddAndRemoveFromFollow < ActiveRecord::Migration[6.0]
  def change
    remove_reference :follows, :content
    add_column :follows, :content_provider_id, :bigint, index: true
  end
end
