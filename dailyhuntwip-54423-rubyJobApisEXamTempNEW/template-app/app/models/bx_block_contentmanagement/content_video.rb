# == Schema Information
#
# Table name: content_videos
#
#  id               :bigint           not null, primary key
#  description      :string
#  headline         :string
#  separate_section :string
#  thumbnails       :string
#  view_count       :bigint           default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  career_expert_id :bigint
#  exam_id          :bigint
#
# Indexes
#
#  index_content_videos_on_career_expert_id  (career_expert_id)
#  index_content_videos_on_exam_id           (exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (career_expert_id => career_experts.id)
#  fk_rails_...  (exam_id => exams.id)
#
module BxBlockContentmanagement
  class ContentVideo < ApplicationRecord
  	include Contentable

    self.table_name = :content_videos

    validates_presence_of :headline
    # validate :validate_video_short_length, if: -> { contentable&.content_type&.video_short? }
    # validate :validate_video_full_length, if: -> { contentable&.content_type&.video_full? }

    has_one :video, as: :attached_item, dependent: :destroy, class_name: 'BxBlockVideos::Video'
    has_one :image, as: :attached_item, dependent: :destroy
    has_many :banners, as: :bannerable, dependent: :destroy
    belongs_to :career_expert, class_name:"BxBlockExperts::CareerExpert", optional: true, foreign_key: "career_expert_id"
    belongs_to :exam, class_name:"BxBlockContentmanagement::Exam", optional: true, foreign_key: "exam_id"
    # http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for
    accepts_nested_attributes_for :video, allow_destroy: true
    accepts_nested_attributes_for :image, allow_destroy: true
    has_many :followers, class_name:"BxBlockContentmanagement::Follow", dependent: :destroy
    has_many :bookmarks, class_name: "BxBlockContentmanagement::Bookmark", as: :bookmarkable, dependent: :destroy

    def name
      headline
    end

    def image_url
      image.image_url if image.present?
    end

    def video_url
      video.video_url if video.present?
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end

    rails_admin do
      configure :description do
        pretty_value do
          value.html_safe
        end
      end

      show do
        field :id
        field :separate_section
        field :headline
        field :description
        field :thumbnails
        field :video do
          pretty_value do
            if bindings[:object].video.present?
              bindings[:view].render partial: 'video_preview', locals: {videos: [bindings[:object].video]}
            end
          end
        end
        field :created_at
      end
    end

    private

    def validate_video_short_length
      if self.video.present? and self.video.video.present?
        errors.add(:video, "can't be more than 30 seconds") if get_time_duration(self.video.video) >= 30
      end
    end

    def validate_video_full_length
      if self.video.present? and self.video.video.present?
        errors.add(:video, "can't be less than 30 seconds") if get_time_duration(self.video.video) < 30
      end
    end

    def get_time_duration(video)
      movie = FFMPEG::Movie.new(video.current_path)
      movie.duration
    end
  end
end
