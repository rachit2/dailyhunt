# == Schema Information
#
# Table name: specializations
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  degree_id                 :bigint
#  higher_education_level_id :bigint
#
module BxBlockProfile
  class SpecializationSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :name,
      :degree,
      :higher_education_level,
      :rank,
      :college,
      :colleges,
      :count,
      :logo
    ]

    attribute :count do |object|
      object.colleges&.count
    end

    attribute :logo do |object|
      object.logo_url if object.logo
    end

  end
end
