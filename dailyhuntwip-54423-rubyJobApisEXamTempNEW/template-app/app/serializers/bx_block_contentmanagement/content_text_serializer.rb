# == Schema Information
#
# Table name: content_texts
#
#  id          :bigint           not null, primary key
#  headline    :string
#  content     :string
#  hyperlink   :string
#  affiliation :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class ContentTextSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :content, :images, :videos,:hyperlink, :featured, :popular, :affiliation,  :career_expert, :bookmark, :tags, :follow, :content_type, :view_count, :created_at, :updated_at

    attributes :images do |object|
      if object.images.present?
        object.images.each do |image|
          image.image_url if image.present?
        end
      else
        []
      end
    end

    attributes :featured do |object|
      object.contentable&.is_featured
    end

    attributes :popular do |object|
      object.contentable&.is_popular
    end

    attributes :tags do |object|
      object.contentable&.tag_list
    end


    attributes :content_type do |object|
      object.contentable&.content_type
    end


    attributes :videos do |object|
      if object.videos.present?
        object.videos.each do |video|
          video.video_url if video.present?
        end
      else
        []
      end
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
