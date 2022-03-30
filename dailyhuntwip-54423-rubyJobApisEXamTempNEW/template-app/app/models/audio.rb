# == Schema Information
#
# Table name: audios
#
#  id                 :bigint           not null, primary key
#  attached_item_type :string
#  audio              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_item_id   :integer
#
# Indexes
#
#  index_audios_on_attached_item_id    (attached_item_id)
#  index_audios_on_attached_item_type  (attached_item_type)
#
class Audio < ApplicationRecord
  mount_uploader :audio, AudioUploader

  # Associations
  belongs_to :attached_item, polymorphic: true

  # Validations
  validates_presence_of :audio
end
