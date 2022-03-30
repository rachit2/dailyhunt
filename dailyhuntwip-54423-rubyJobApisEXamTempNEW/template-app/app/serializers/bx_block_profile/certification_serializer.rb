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
  class CertificationSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :certification_course_name,
      :provided_by,
      :duration,
      :completion_year
    ]

  end
end
