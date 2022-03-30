# == Schema Information
#
# Table name: audio_podcasts
#
#  id          :bigint           not null, primary key
#  description :string
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class AudioPodcastSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :category, :sub_category, :follow, :tag_list, :is_popular, :is_trending, :image, :audio, :created_at, :updated_at
    attribute :category do |object|
      object.contentable.category
    end
    attribute :is_trending do |object|
      object.contentable.is_trending
    end
    attribute :is_popular do |object|
      object.contentable.is_popular
    end
    attribute :sub_category do |object|
      object.contentable.sub_category
    end
    attribute :follow do |object, params|
      params && params[:current_user_id] && current_user_following(object, params[:current_user_id])
    end
    attribute :tag_list do |object|
      object.contentable.tag_list
    end
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
    attributes :audio do |object|
      object.audio.audio_url if object.audio.present?
    end

    class << self
      private

      def current_user_following(record, current_user_id)
        AccountBlock::Account.find(current_user_id).content_provider_followings.where(id: record.contentable.admin_user).present?
      end
    end
  end
end
