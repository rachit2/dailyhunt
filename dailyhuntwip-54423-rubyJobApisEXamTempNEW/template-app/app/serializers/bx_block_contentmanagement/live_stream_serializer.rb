# == Schema Information
#
# Table name: live_streams
#
#  id          :bigint           not null, primary key
#  description :string
#  headline    :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class LiveStreamSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :url, :image_url, :created_at, :updated_at
    
    attributes :image_url do |object|
      object.image.image_url if object.image.present?
    end
  end
end
