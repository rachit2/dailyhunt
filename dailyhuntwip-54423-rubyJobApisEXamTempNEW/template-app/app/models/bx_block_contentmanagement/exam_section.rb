# frozen_string_literal: true

# == Schema Information
#
# Table name: exam_sections
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint           not null
#
# Indexes
#
#  index_exam_sections_on_exam_id  (exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#
module BxBlockContentmanagement
  class ExamSection < ApplicationRecord
    self.table_name = :exam_sections

    belongs_to :exam, inverse_of: :exam_sections

    validates :title, :body, presence: true
  end
end
