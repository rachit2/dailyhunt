class AddFlagsInCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :is_popular, :boolean, default: false
    add_column :courses, :is_tranding, :boolean, default: false
    add_column :courses, :is_premium, :boolean, default: false
    add_column :courses, :thumbnail, :string
    add_column :courses, :video, :string
  end
end
