module BxBlockContentmanagement
  class TagSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :taggings_count, :created_at, :updated_at
    
    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end
end
