# == Schema Information
#
# Table name: banners
#
#  id              :bigint           not null, primary key
#  bannerable_type :string
#  end_time        :datetime
#  image           :string
#  is_article      :boolean
#  is_explore      :boolean
#  is_video        :boolean
#  rank            :integer
#  start_time      :datetime
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bannerable_id   :integer
#
module BxBlockContentmanagement
	class Banner < ApplicationRecord
		self.table_name = :banners

		mount_uploader :image, ImageUploader
		enum status: ["draft", "publish", "disable"]
		belongs_to :bannerable, polymorphic: true, optional: true
		validates :image, :status, :start_time, :end_time, presence: true

		TYPE_MAPPINGS = {
      "course" => BxBlockContentmanagement::Course.name,
      "job" => BxBlockJobs::Job.name,
      "career_expert"=>BxBlockExperts::CareerExpert.name,
      "exam" => BxBlockContentmanagement::Exam.name,
      "quiz" => BxBlockContentmanagement::Quiz.name,
      "assessment" => BxBlockContentmanagement::Assessment.name,
      "article" => BxBlockContentmanagement::ContentText.name,
      "video" => BxBlockContentmanagement::ContentVideo.name,
      "live_stream" => BxBlockContentmanagement::LiveStream.name,
      "audio_podcast" => BxBlockContentmanagement::AudioPodcast.name,
      "study_material" => BxBlockContentmanagement::Test.name,
      "epub" => BxBlockContentmanagement::Epub.name
    }.freeze

		rails_admin do
			field :image
			field :bannerable_type do
				partial "bannerable_type_partial"
			end
			field :bannerable_id do
				partial "bannerable_id_partial"
			end
      field :status
      field :is_article
      field :is_video
      field :is_explore
      field :rank
      field :start_time
      field :end_time
    end
	end
end
