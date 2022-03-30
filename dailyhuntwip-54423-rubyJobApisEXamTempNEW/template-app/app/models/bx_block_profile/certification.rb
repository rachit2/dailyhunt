# == Schema Information
#
# Table name: certifications
#
#  id                        :bigint           not null, primary key
#  certification_course_name :string
#  provided_by               :string
#  duration                  :integer
#  completion_year           :integer
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module BxBlockProfile
  class Certification < ApplicationRecord
    self.table_name = :certifications
    
    has_many :certification_profiles, class_name: 'BxBlockProfile::CertificationProfile', dependent: :destroy
    validates :certification_course_name, presence:true
  end
end
