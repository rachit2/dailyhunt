# == Schema Information
#
# Table name: follows
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#  content_provider_id :bigint
#
# Indexes
#
#  index_follows_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
module BxBlockContentmanagement
  class FollowSerializer < BuilderBase::BaseSerializer
    attributes :id, :account, :content_provider, :created_at, :updated_at, :content_articles, :content_videos, :content_blogs

    attribute :content_videos do |object, params|
      BxBlockContentmanagement::ContentVideoSerializer.new(object.content_video,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data]
    end

    attribute :content_articles do |object, params|
      BxBlockContentmanagement::ContentTextSerializer.new(object.content_text,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data] if object.article_content
    end

    attribute :content_blogs do |object, params|
      BxBlockContentmanagement::ContentTextSerializer.new(object.content_text,params:{current_user_id:params[:current_user_id]})&.serializable_hash[:data] if object.blog_content
    end

  end
end
