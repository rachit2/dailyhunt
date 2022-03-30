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
module BxBlockProfile
  class SubjectEducationLevelProfile < ApplicationRecord
    self.table_name = :subject_education_levels

    belongs_to :education_level_profile, class_name: 'BxBlockProfile::EducationLevelProfile', foreign_key: :education_level_profile_id,optional: true
    belongs_to :subject, class_name: 'BxBlockProfile::Subject', foreign_key: :subject_id

  end
end
