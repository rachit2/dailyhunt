module BxBlockProfile
  class CitySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :latitude, :longitude, :logo, :created_at, :updated_at


    attribute :logo do |object|
      object.logo.url if object.logo&.present?
    end

  end
end
