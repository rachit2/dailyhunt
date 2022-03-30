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
  class EducationLevelProfileSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :education_level,
      :board,
      :standard,
      :degree,
      :college,
      :specialization,
      :educational_course,
      :passing_year,
      :college_name,
      :school_name,
      :subjects
    ]

    attributes :above_12 do |object|
      object.education_level.level == 'above 10+2'
    end

    attributes :educational_course do |object|
      object.educational_course
    end
    
    attributes :name do |object|
      object.education_level.name if object.education_level.present?
    end

    attributes :subjects do |object|
      object.subjects
    end

  end
end
