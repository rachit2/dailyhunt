class AddHeadingInJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :heading, :string
  end
end
