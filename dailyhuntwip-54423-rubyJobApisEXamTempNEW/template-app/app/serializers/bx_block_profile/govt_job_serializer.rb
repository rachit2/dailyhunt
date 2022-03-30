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
  class GovtJobSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :higher_education_level,
      :specialization,
      :caste_category
    ]

    attributes :higher_education_level do |object|
      BxBlockProfile::EducationLevelSerializer.new(object.education_level) if object.education_level.present?
    end

    attributes :specialization do |object|
      object.specialization if object.specialization.present?
    end

    attributes :caste_category do |object|
      object.caste_category if object.caste_category.present?
    end

  end
end
