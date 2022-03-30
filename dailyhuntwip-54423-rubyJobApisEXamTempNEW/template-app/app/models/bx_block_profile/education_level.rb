# == Schema Information
#
# Table name: education_levels
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  level      :integer
#
module BxBlockProfile
  class EducationLevel < ApplicationRecord
    self.table_name = :education_levels

    enum level: ["below 10+2", "10+2", "above 10+2"]
    has_many :specialization_education_levels, class_name: 'BxBlockProfile::SpecializationEducationLevel', dependent: :destroy
    has_many :education_level_profiles, class_name: 'BxBlockProfile::EducationLevelProfile', dependent: :destroy
    has_many :specializations, class_name: 'BxBlockProfile::Specialization', foreign_key: :higher_education_level_id, dependent: :nullify
    has_many :govt_jobs, class_name: 'BxBlockProfile::GovtJob', dependent: :nullify
    has_many :profiles, class_name: 'BxBlockProfile::Profile', foreign_key: :higher_education_level_id, dependent: :nullify

    validates :name, uniqueness: true, presence:true
  end
end
