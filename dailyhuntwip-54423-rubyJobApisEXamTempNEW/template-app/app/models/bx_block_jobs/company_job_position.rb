# == Schema Information
#
# Table name: company_job_positions
#
#  id              :bigint           not null, primary key
#  employment_type :string
#  is_vacant       :boolean
#  salary          :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :integer
#  job_id          :integer
#
class BxBlockJobs::CompanyJobPosition < ApplicationRecord
  self.table_name = "company_job_positions"
  belongs_to :company, class_name:"BxBlockCompany::Company"
  belongs_to :job, class_name:"BxBlockJobs::Job"

  scope :vacant_jobs, -> {where(is_vacant:true)}

  def self.vacant_positions
    vacant_jobs.map{|a|a.job}
  end


end
