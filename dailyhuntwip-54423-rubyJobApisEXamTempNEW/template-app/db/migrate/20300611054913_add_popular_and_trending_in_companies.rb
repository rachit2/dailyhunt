class AddPopularAndTrendingInCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :popular, :boolean
    add_column :companies, :trending, :boolean
  end
end
