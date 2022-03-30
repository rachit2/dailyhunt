# == Schema Information
#
# Table name: lession_contents
#
#  id           :bigint           not null, primary key
#  content_type :integer
#  description  :text
#  duration     :integer
#  file_content :string
#  heading      :string
#  is_free      :boolean          default(FALSE)
#  rank         :integer
#  thumbnail    :string
#  video        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lession_id   :bigint           not null
#
# Indexes
#
#  index_lession_contents_on_lession_id  (lession_id)
#
# Foreign Keys
#
#  fk_rails_...  (lession_id => lessions.id)
#
module BxBlockContentmanagement
  class LessionContent < ApplicationRecord
    self.table_name = :lession_contents
    before_validation :update_duration_data
    enum content_type: [:word, :excel, :ppt, :pdf, :video_content]
    mount_uploader :video, VideoUploader
    mount_uploader :file_content, PdfUploader
    mount_uploader :thumbnail, ImageUploader

    belongs_to :lession, inverse_of: :lession_contents
    has_many :courses_lession_contents, class_name: 'BxBlockContentmanagement::CoursesLessionContent'

    # Validations
    validates_presence_of :video, if:->{ self.video_content? }
    validates_presence_of :file_content, if:->{ self.pdf? || self.word? || self.excel? || self.ppt? }
    validates_absence_of :video, unless:->{ self.video_content? }
    validates_absence_of :file_content, unless:->{ self.pdf? || self.word? || self.excel? || self.ppt? }
    validates_presence_of :heading, :description, :content_type

    def update_duration_data
      self.duration = Videotime.get_video_time(video.path) if video
    end

    rails_admin do
      edit do
        field :heading
        field :description
        field :rank
        field :is_free
        field :lession
        field :content_type
        field :thumbnail, :carrierwave
        field :video, :carrierwave
        field :file_content, :carrierwave
      end
    end

  end
end
