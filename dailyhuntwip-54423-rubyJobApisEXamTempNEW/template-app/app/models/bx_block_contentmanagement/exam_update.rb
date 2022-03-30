# frozen_string_literal: true

# == Schema Information
#
# Table name: exam_updates
#
#  id             :bigint           not null, primary key
#  date           :date
#  link           :string
#  update_message :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  exam_id        :bigint
#
# Indexes
#
#  index_exam_updates_on_exam_id  (exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#
module BxBlockContentmanagement
  class ExamUpdate < ApplicationRecord
    self.table_name = :exam_updates

    belongs_to :exam, inverse_of: :exam_updates

    validates :date, :update_message, :link, presence: true
  end
end
