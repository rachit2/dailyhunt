# == Schema Information
#
# Table name: account_jobs
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :string
#  company_id :string
#  job_id     :string
#
class BxBlockJobs::AccountJob < ApplicationRecord
  self.table_name = :account_jobs
  belongs_to :company, class_name:"BxBlockCompany::Company"
  belongs_to :job, class_name: "BxBlockJobs::Job"
  belongs_to :account, class_name: "AccountBlock::Account"
end
