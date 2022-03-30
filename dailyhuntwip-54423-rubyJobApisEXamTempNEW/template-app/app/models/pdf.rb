# == Schema Information
#
# Table name: pdfs
#
#  id                 :bigint           not null, primary key
#  attached_item_type :string
#  pdf                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_item_id   :integer
#
# Indexes
#
#  index_pdfs_on_attached_item_id    (attached_item_id)
#  index_pdfs_on_attached_item_type  (attached_item_type)
#
class Pdf < ApplicationRecord
  mount_uploader :pdf, PdfUploader

  # Associations
  belongs_to :attached_item, polymorphic: true, inverse_of: :pdfs

  # Validations
  validates_presence_of :pdf
end
