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
  class EducationLevelSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :rank, 
      :above_12
    ]

    attributes :above_12 do |object|
      object.level == 'above 10+2'
    end

  end
end
