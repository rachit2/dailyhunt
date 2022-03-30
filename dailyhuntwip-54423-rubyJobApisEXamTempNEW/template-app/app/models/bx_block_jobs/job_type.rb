# == Schema Information
#
# Table name: job_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BxBlockJobs::JobType < ApplicationRecord
  self.table_name = :job_types
end
