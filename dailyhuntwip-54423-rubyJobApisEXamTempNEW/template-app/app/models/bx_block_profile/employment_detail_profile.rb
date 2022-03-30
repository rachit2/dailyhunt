# == Schema Information
#
# Table name: employment_detail_profiles
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  employment_detail_id :bigint           not null
#  profile_id           :bigint           not null
#
# Indexes
#
#  index_employment_detail_profiles_on_employment_detail_id  (employment_detail_id)
#  index_employment_detail_profiles_on_profile_id            (profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (employment_detail_id => employment_details.id)
#  fk_rails_...  (profile_id => profiles.id)
#
module BxBlockProfile
  class EmploymentDetailProfile < ApplicationRecord
    self.table_name = :employment_detail_profiles
     
    belongs_to :employment_detail
    belongs_to :profile
  end
end
