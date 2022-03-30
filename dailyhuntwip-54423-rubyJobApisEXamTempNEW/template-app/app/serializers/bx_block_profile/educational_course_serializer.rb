# == Schema Information
#
# Table name: educational_courses
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class EducationalCourseSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :rank
    ]

  end
end
