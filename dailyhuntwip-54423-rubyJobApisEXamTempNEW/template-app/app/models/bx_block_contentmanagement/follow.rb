# == Schema Information
#
# Table name: follows
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#  content_provider_id :bigint
#  content_text_id     :bigint
#  content_video_id    :bigint
#
# Indexes
#
#  index_follows_on_account_id        (account_id)
#  index_follows_on_content_text_id   (content_text_id)
#  index_follows_on_content_video_id  (content_video_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (content_text_id => content_texts.id)
#  fk_rails_...  (content_video_id => content_videos.id)
#
module BxBlockContentmanagement
  class Follow < ApplicationRecord
    self.table_name = :follows
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :content_provider, class_name: "BxBlockAdmin::AdminUser", foreign_key: 'content_provider_id', optional: true
    # validates :account_id, uniqueness: { scope: :content_provider_id, message: "content provider with this account is already taken"}
    belongs_to :content_text, class_name: "BxBlockContentmanagement::ContentText", optional: true
    belongs_to :content_video, class_name: "BxBlockContentmanagement::ContentVideo", optional: true

   def content_type
      content_text&.contentable&.content_type&.identifier
   end

    def blog_content
      content_type == "blog"
    end

    def article_content
      content_type == "news_article"
    end

    def self.join_contetable_type
      joins(content_text: [contentable: :content_type])
    end

    def self.blog_follows
      join_contetable_type.where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["blog"]})
    end

    def self.article_follows
      join_contetable_type.where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["news_article"]})
    end

  end
end
