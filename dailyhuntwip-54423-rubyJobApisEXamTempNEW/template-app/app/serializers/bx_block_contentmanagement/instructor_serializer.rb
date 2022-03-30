# == Schema Information
#
# Table name: instructors
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockContentmanagement
  class InstructorSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :bio, :designation, :created_at, :updated_at
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
  end
end
