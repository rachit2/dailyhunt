class AddImageInCareerExperts < ActiveRecord::Migration[6.0]
  def change
    add_column :career_experts, :image, :string
  end
end
