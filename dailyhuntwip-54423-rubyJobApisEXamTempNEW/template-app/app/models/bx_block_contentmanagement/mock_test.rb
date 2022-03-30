# == Schema Information
#
# Table name: mock_tests
#
#  id          :bigint           not null, primary key
#  description :string
#  heading     :string
#  pdf         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exam_id     :integer
#
class BxBlockContentmanagement::MockTest < ApplicationRecord

  self.table_name = :mock_tests
  belongs_to :exam, class_name:"BxBlockContentmanagement::Exam"
  mount_uploader :pdf, PdfUploader
  validates_presence_of :description, :heading, :pdf
end
