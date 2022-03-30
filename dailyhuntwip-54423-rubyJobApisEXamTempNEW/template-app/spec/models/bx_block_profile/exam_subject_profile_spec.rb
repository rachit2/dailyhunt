# == Schema Information
#
# Table name: exam_subject_profiles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :bigint           not null
#  subject_id :bigint           not null
#
# Indexes
#
#  index_exam_subject_profiles_on_profile_id  (profile_id)
#  index_exam_subject_profiles_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (profile_id => profiles.id)
#  fk_rails_...  (subject_id => subjects.id)
#
require 'rails_helper'

RSpec.describe BxBlockProfile::ExamSubjectProfile, type: :model do
  describe 'associations' do
    it { should belong_to(:profile) }
    it { should belong_to(:subject) }
  end
end
