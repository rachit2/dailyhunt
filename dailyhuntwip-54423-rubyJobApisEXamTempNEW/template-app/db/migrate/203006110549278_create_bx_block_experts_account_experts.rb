class CreateBxBlockExpertsAccountExperts < ActiveRecord::Migration[6.0]
  def change
    create_table :account_experts do |t|
      t.integer :account_id
      t.integer :career_expert_id
      t.integer :mode
      t.timestamps
    end
  end
end
