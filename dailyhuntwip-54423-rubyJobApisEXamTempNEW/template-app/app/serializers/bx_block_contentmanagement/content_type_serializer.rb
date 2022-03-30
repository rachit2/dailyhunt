# == Schema Information
#
# Table name: content_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  type       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :integer
#  rank       :integer
#
module BxBlockContentmanagement
  class ContentTypeSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :type, :identifier, :created_at, :updated_at
    
    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end
end
