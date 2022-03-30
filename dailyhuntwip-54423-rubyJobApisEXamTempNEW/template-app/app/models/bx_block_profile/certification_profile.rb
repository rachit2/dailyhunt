# == Schema Information
#
# Table name: certification_profiles
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certification_id :bigint           not null
#  profile_id       :bigint           not null
#
# Indexes
#
#  index_certification_profiles_on_certification_id  (certification_id)
#  index_certification_profiles_on_profile_id        (profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (certification_id => certifications.id)
#  fk_rails_...  (profile_id => profiles.id)
#
module BxBlockProfile
  class CertificationProfile < ApplicationRecord
    self.table_name = :certification_profiles
    
    belongs_to :certification
    belongs_to :profile
  end
end
