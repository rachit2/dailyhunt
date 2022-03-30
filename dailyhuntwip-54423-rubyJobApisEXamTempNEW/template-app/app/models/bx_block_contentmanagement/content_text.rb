# == Schema Information
#
# Table name: content_texts
#
#  id               :bigint           not null, primary key
#  affiliation      :string
#  content          :string
#  headline         :string
#  hyperlink        :string
#  view_count       :bigint           default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  career_expert_id :bigint
#
# Indexes
#
#  index_content_texts_on_career_expert_id  (career_expert_id)
#
# Foreign Keys
#
#  fk_rails_...  (career_expert_id => career_experts.id)
#
module BxBlockContentmanagement
  class ContentText < ApplicationRecord
    include Contentable

    self.table_name = :content_texts

    validates_presence_of :headline, :content
    belongs_to :career_expert, class_name:"BxBlockExperts::CareerExpert", optional: true, foreign_key: "career_expert_id"

    has_many :images, as: :attached_item, dependent: :destroy
    has_many :videos, as: :attached_item, dependent: :destroy, class_name: 'BxBlockVideos::Video'
    accepts_nested_attributes_for :videos, allow_destroy: true
    accepts_nested_attributes_for :images, allow_destroy: true
    has_many :banners, as: :bannerable, dependent: :destroy
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy
    has_many :followers, class_name:"BxBlockContentmanagement::Follow", dependent: :destroy

    def name
      headline
    end

    def description
      content
    end

    def image_url
      images.first.image_url if images.present?
    end

    def video_url
      videos.first.video_url if videos.present?
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end

    rails_admin do
      configure :content do
        pretty_value do
          value.html_safe
        end
      end

      show do
        field :id
        field :headline
        field :content
        field :hyperlink
        field :affiliation
        field :images do
          pretty_value do
            if bindings[:object].images.present?
              bindings[:view].render partial: 'image_preview', locals: {images: bindings[:object].images}
            end
          end
        end
        field :videos do
          pretty_value do
            if bindings[:object].videos.present?
              bindings[:view].render partial: 'video_preview', locals: {videos: bindings[:object].videos}
            end
          end
        end
        field :created_at
      end
    end

  end
end
