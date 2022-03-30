class AddHeadingInCareerExperts < ActiveRecord::Migration[6.0]
  def change
    add_column :career_experts, :heading, :string
  end
end
