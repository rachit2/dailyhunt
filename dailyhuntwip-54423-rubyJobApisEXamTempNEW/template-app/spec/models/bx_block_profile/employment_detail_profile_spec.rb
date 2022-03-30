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
require 'rails_helper'

RSpec.describe BxBlockProfile::EmploymentDetailProfile, type: :model do
  describe 'associations' do
    it { should belong_to(:employment_detail).class_name('BxBlockProfile::EmploymentDetail') }
    it { should belong_to(:profile).class_name('BxBlockProfile::Profile') }
  end
end
