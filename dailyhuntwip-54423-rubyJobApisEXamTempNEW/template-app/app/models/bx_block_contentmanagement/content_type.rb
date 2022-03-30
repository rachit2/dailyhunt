# == Schema Information
#
# Table name: content_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  type       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :integer
#  rank       :integer
#
module BxBlockContentmanagement
  class ContentType < ApplicationRecord
    self.inheritance_column = nil
    self.table_name = :content_types

    TYPE_MAPPINGS = {
      "Text" => BxBlockContentmanagement::ContentText.name,
      "Videos" => BxBlockContentmanagement::ContentVideo.name,
      "Live Stream" => BxBlockContentmanagement::LiveStream.name,
      "AudioPodcast" => BxBlockContentmanagement::AudioPodcast.name,
      "Test" => BxBlockContentmanagement::Test.name,
      "Epub" => BxBlockContentmanagement::Epub.name
    }.freeze

    validates_presence_of :name, :type
    validates_uniqueness_of :name, case_sensitive: false
    validates_uniqueness_of :identifier, allow_blank: true

    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy
    has_and_belongs_to_many :partners, class_name: 'BxBlockRolesPermissions::Partner', join_table: :content_types_partners, dependent: :destroy


    enum type: ["Text", "Videos", "Live Stream", "AudioPodcast", "Test", "Epub"]

    enum identifier: ["news_article", "audio_podcast", "blog", "live_streaming", "study_material", "video_short", "video_full"]

    def type_class
      TYPE_MAPPINGS[type]
    end

    rails_admin do
      list do
        field :name
        field :type
        field :rank
        field :identifier do
          filterable false
        end
        field :created_at
        field :updated_at
      end

      edit do
        field :name do
          label 'Name of the Content Type'
        end
        field :rank
        field :type do
          read_only do 
            if !bindings[:object].new_record?
               bindings[:object].type
            end  
          end
        end  

        field :identifier
      end
    end
  end
end
