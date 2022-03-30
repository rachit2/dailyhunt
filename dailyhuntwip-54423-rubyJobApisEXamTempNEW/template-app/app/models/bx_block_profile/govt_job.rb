# == Schema Information
#
# Table name: govt_jobs
#
#  id                 :bigint           not null, primary key
#  caste_category     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  education_level_id :bigint
#  profile_id         :bigint
#  specialization_id  :bigint
#
# Indexes
#
#  index_govt_jobs_on_education_level_id  (education_level_id)
#  index_govt_jobs_on_profile_id          (profile_id)
#  index_govt_jobs_on_specialization_id   (specialization_id)
#
# Foreign Keys
#
#  fk_rails_...  (education_level_id => education_levels.id)
#  fk_rails_...  (profile_id => profiles.id)
#  fk_rails_...  (specialization_id => specializations.id)
#
module BxBlockProfile
  class GovtJob < ApplicationRecord
    self.table_name = :govt_jobs
    
    belongs_to :education_level
    belongs_to :specialization, optional: true
    belongs_to :profile

    enum caste_category: ["general", "obc", "sc", "st"]
  end
end
