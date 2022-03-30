module BxBlockProfile
  class UniversitySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :is_featured, :logo, :location, :degrees, :created_at, :updated_at

    attribute :logo do |object|
      object.logo if object.logo.present?
    end

    attributes :location do |object|
      LocationSerializer.new(object.location)
    end

    attributes :degrees do |object|
      DegreeSerializer.new(object.degrees)
    end

  end
end