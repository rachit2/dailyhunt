class AddTrendingAndPopularIntoJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :popular, :boolean
    add_column :jobs, :trending, :boolean
  end
end