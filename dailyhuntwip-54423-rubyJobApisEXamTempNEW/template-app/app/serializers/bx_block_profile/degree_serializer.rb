# == Schema Information
#
# Table name: degrees
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockProfile
  class DegreeSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :rank, :specializations, :created_at, :updated_at

    attributes :specializations do |object|
      SpecializationSerializer.new(object.specializations)
    end

  end
end
