# == Schema Information
#
# Table name: job_places
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  job_id          :integer
#  job_location_id :integer
#
class BxBlockJobs::JobPlace < ApplicationRecord
  self.table_name = :job_places
  belongs_to :job
  belongs_to :job_location
end
