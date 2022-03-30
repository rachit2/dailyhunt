# == Schema Information
#
# Table name: subject_education_levels
#
#  id                         :bigint           not null, primary key
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  education_level_profile_id :bigint
#  subject_id                 :bigint
#
# Indexes
#
#  index_subject_education_levels_on_education_level_profile_id  (education_level_profile_id)
#  index_subject_education_levels_on_subject_id                  (subject_id)
#
require 'rails_helper'

RSpec.describe BxBlockProfile::SubjectEducationLevelProfile, type: :model do
  # it { should belongs_to(:subject) }
end
