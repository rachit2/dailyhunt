module BxBlockContentmanagement
  class BannerableSerializer < BuilderBase::BaseSerializer
    attributes :id, :name

    attribute :name do |object|
      object.name
    end
  end
end
