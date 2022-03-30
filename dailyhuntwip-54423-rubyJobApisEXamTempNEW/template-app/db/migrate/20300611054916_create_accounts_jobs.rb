class CreateAccountsJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts_jobs do |t|
      t.belongs_to :account
      t.belongs_to :job
    end
  end
end
