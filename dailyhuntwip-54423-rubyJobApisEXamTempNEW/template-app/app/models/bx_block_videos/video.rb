# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  attached_item_type :string
#  video              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_item_id   :integer
#
# Indexes
#
#  index_videos_on_attached_item_id    (attached_item_id)
#  index_videos_on_attached_item_type  (attached_item_type)
#
module BxBlockVideos
  class Video < ApplicationRecord
    self.table_name = :videos
    mount_uploader :video, VideoUploader

    # Associations
    belongs_to :attached_item, polymorphic: true

    # Validations
    validates_presence_of :video
  end
end
