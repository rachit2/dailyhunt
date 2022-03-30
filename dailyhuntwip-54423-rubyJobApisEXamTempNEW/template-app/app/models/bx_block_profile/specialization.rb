# == Schema Information
#
# Table name: specializations
#
#  id                        :bigint           not null, primary key
#  logo                      :string
#  name                      :string
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  college_id                :integer
#  degree_id                 :bigint
#  higher_education_level_id :bigint
#
module BxBlockProfile
  class Specialization < ApplicationRecord
    self.table_name = :specializations
    mount_uploader :logo, ImageUploader
    has_many :specialization_education_levels, class_name: 'BxBlockProfile::SpecializationEducationLevel', dependent: :destroy
    has_many :education_level_profiles, class_name: 'BxBlockProfile::EducationLevelProfile', dependent: :nullify
    belongs_to :degree, class_name: "BxBlockProfile::Degree", foreign_key: "degree_id", optional: true
    belongs_to :higher_education_level, class_name: "BxBlockProfile::EducationLevel", foreign_key: "higher_education_level_id", optional: true
    belongs_to :college, optional: true
    has_and_belongs_to_many :colleges, class_name: "BxBlockProfile::College"
    validates :name, uniqueness: true, presence:true
  end
end
