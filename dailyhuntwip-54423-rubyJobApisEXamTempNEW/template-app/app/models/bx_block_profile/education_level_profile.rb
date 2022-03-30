# == Schema Information
#
# Table name: education_level_profiles
#
#  id                    :bigint           not null, primary key
#  college_name          :string
#  passing_year          :string
#  school_name           :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  board_id              :bigint
#  college_id            :bigint
#  degree_id             :bigint
#  education_level_id    :bigint           not null
#  educational_course_id :integer
#  profile_id            :bigint           not null
#  specialization_id     :bigint
#  standard_id           :bigint
#
# Indexes
#
#  index_education_level_profiles_on_board_id            (board_id)
#  index_education_level_profiles_on_college_id          (college_id)
#  index_education_level_profiles_on_degree_id           (degree_id)
#  index_education_level_profiles_on_education_level_id  (education_level_id)
#  index_education_level_profiles_on_profile_id          (profile_id)
#  index_education_level_profiles_on_standard_id         (standard_id)
#
# Foreign Keys
#
#  fk_rails_...  (education_level_id => education_levels.id)
#  fk_rails_...  (profile_id => profiles.id)
#
module BxBlockProfile
  class EducationLevelProfile < ApplicationRecord
    self.table_name = :education_level_profiles
   
    belongs_to :education_level
    belongs_to :profile
    belongs_to :board, class_name: 'BxBlockProfile::Board', optional: true
    belongs_to :specialization, class_name: 'BxBlockProfile::Specialization', optional: true
    belongs_to :standard, class_name: 'BxBlockProfile::Standard', optional: true
    belongs_to :degree, class_name: 'BxBlockProfile::Degree', optional: true
    belongs_to :college, class_name: 'BxBlockProfile::College', optional: true
    belongs_to :educational_course, class_name: 'BxBlockProfile::EducationalCourse', optional: true, foreign_key: :educational_course_id
    has_many :subject_education_level_profiles, class_name: 'BxBlockProfile::SubjectEducationLevelProfile', foreign_key: :education_level_profile_id, dependent: :destroy
    has_many :subjects, class_name: 'BxBlockProfile::Subject', through: :subject_education_level_profiles

  end
end
