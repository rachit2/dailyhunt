# == Schema Information
#
# Table name: content_videos
#
#  id               :bigint           not null, primary key
#  separate_section :string
#  headline         :string
#  description      :string
#  thumbnails       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module BxBlockContentmanagement
  class ContentVideoSerializer < BuilderBase::BaseSerializer
    attributes :id, :separate_section, :headline, :description, :thumbnails, :image, :exam, :featured, :popular, :career_expert, :tags, :video, :content_type, :bookmark, :view_count, :created_at, :updated_at


    attributes :tags do |object|
      object.contentable&.tag_list
    end

    attributes :featured do |object|
      object.contentable&.is_featured
    end

    attributes :popular do |object|
      object.contentable&.is_popular
    end

    attributes :image do |object|

      object.image.image_url if object.image.present?
    end

    attributes :content_type do |object|
      object.contentable&.content_type
    end

    attributes :video do |object|
      object.video.video_url if object.video.present?
    end

    attribute :bookmark do |object, params|
      params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id])
    end

    attribute :follow do |object, params|
      params && params[:current_user_id] && current_user_follow(object, params[:current_user_id])
    end

    class << self
      private
      def current_user_bookmark(object, current_user_id)
        object.bookmarks.where(account_id: current_user_id).present?
      end

      def current_user_follow(object, current_user_id)
        object.followers.where(account_id:current_user_id).present?
      end
    end

  end
end
