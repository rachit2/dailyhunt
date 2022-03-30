class AddRatingInCareerExperts < ActiveRecord::Migration[6.0]
  def change
    add_column :career_experts, :rating, :integer
  end
end
