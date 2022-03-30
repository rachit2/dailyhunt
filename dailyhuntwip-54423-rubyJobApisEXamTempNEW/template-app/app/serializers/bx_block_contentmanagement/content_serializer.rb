# == Schema Information
#
# Table name: contents
#
#  id               :bigint           not null, primary key
#  archived         :boolean          default(FALSE)
#  contentable_type :string
#  crm_type         :integer
#  detail_url       :string
#  feature_article  :boolean
#  feature_video    :boolean
#  feedback         :string
#  is_popular       :boolean
#  is_trending      :boolean
#  publish_date     :datetime
#  review_status    :integer
#  searchable_text  :string
#  status           :integer
#  view_count       :bigint           default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  admin_user_id    :integer
#  author_id        :bigint
#  category_id      :integer
#  content_type_id  :integer
#  contentable_id   :bigint
#  crm_id           :integer
#  language_id      :integer
#  sub_category_id  :integer
#
# Indexes
#
#  index_contents_on_author_id                            (author_id)
#  index_contents_on_contentable_type_and_contentable_id  (contentable_type,contentable_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#
module BxBlockContentmanagement
  class ContentSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :description, :image, :video, :audio, :study_material, :category, :sub_category, :language, :content_type, :contentable, :feature_article, :feature_video, :is_trending, :is_popular, :tag_list, :status, :publish_date, :view_count, :created_at, :updated_at

    attribute :bookmark do |object, params|
      params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id])
    end

    attribute :follow do |object, params|
      params && params[:current_user_id] && current_user_following(object, params[:current_user_id])
    end

    attribute :image do |object|
      object.image if object.image.present?
    end

    attribute :video do |object|
      object.video if object.video.present?
    end

    attribute :audio do |object|
      object.audio if object.audio.present?
    end

    attribute :study_material do |object|
      object.study_material if object.study_material.present?
    end

    attribute :content_provider do |object|
      BxBlockContentmanagement::ContentProviderSerializer.new(object.admin_user) if object.admin_user&.partner?
    end

    attributes :contentable do |object|
      case object&.content_type&.type
      when "Live Stream"
        BxBlockContentmanagement::LiveStreamSerializer.new(object.contentable)
      when "Videos"
        BxBlockContentmanagement::ContentVideoSerializer.new(object.contentable)
      when "Text"
        BxBlockContentmanagement::ContentTextSerializer.new(object.contentable)
      when "AudioPodcast"
        BxBlockContentmanagement::AudioPodcastSerializer.new(object.contentable)
      when "Test"
        BxBlockContentmanagement::TestSerializer.new(object.contentable)
      when "Epub"
        BxBlockContentmanagement::EpubSerializer.new(object.contentable)
      end
    end

    class << self
      private
      def current_user_bookmark(record, current_user_id)
        record.bookmarks.where(account_id: current_user_id).present?
      end

      def current_user_following(record, current_user_id)
        AccountBlock::Account.find(current_user_id).content_provider_followings.where(id: record.admin_user).present?
      end
    end
  end
end
