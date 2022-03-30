# == Schema Information
#
# Table name: epubs
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class EpubSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :files, :description, :thumbnail, :is_trending, :is_popular, :created_at, :updated_at

    attribute :category do |object|
      object.contentable.category rescue nil
    end
    attribute :sub_category do |object|
      object.contentable.sub_category rescue nil
    end
    attributes :thumbnail do |object|
      object.image.image_url if object.image.present?
    end
    attribute :is_trending do |object|
      object.contentable.is_trending
    end
    attribute :is_popular do |object|
      object.contentable.is_popular
    end
    attribute :follow do |object, params|
      params && params[:current_user_id] && current_user_following(object, params[:current_user_id])
    end
    attribute :tag_list do |object|
      object.contentable.tag_list rescue nil
    end

    attributes :files do |object|
      if object.pdfs.present?
        object.pdfs.each do |pdf|
          pdf.pdf_url if pdf.present?
        end
      else
        []
      end
    end

    class << self
      private

      def current_user_following(record, current_user_id)
        AccountBlock::Account.find(current_user_id).content_provider_followings.where(id: record.admin_user).present?
      end
    end
  end
end
