# == Schema Information
#
# Table name: banners
#
#  id              :bigint           not null, primary key
#  bannerable_type :string
#  end_time        :datetime
#  image           :string
#  is_explore      :boolean
#  rank            :integer
#  start_time      :datetime
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bannerable_id   :integer
#
module BxBlockContentmanagement
  class BannerSerializer < BuilderBase::BaseSerializer
    attributes :id, :image, :bannerable, :status, :start_time, :end_time, :rank, :is_explore, :is_article, :is_video, :created_at, :updated_at
    attributes :image do |object|
      object.image_url if object.image.present?
    end
  end
end
