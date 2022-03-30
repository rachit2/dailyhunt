# == Schema Information
#
# Table name: job_categories
#
#  id         :bigint           not null, primary key
#  logo       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BxBlockJobs::JobCategory < ApplicationRecord
  self.table_name = :job_categories
  mount_uploader :logo, ImageUploader
  has_many :jobs, class_name: "BxBlockJobs::Job"
  has_many :companies, through: :jobs, class_name:"BxBlockCompany::Company"
  validates :name,  presence: true


   rails_admin do
      edit do
        field :name
        field :jobs
        field :companies
        field :logo, :carrierwave
      end
    end
end
