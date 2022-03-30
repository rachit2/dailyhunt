# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockContentmanagement
  class AuthorSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :bio, :created_at, :updated_at
    attributes :contents do |object|
      BxBlockContentmanagement::ContentSerializer.new(object.contents)
    end
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
  end
end
