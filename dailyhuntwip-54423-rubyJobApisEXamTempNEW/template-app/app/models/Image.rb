# == Schema Information
#
# Table name: images
#
#  id                 :bigint           not null, primary key
#  attached_item_type :string
#  image              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_item_id   :integer
#
# Indexes
#
#  index_images_on_attached_item_id    (attached_item_id)
#  index_images_on_attached_item_type  (attached_item_type)
#
class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  # Associations
  belongs_to :attached_item, polymorphic: true

  # Validations
  validates_presence_of :image
end
