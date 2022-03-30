# == Schema Information
#
# Table name: courses_lession_contents
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  course_id           :integer
#  lessions_content_id :integer
#

module BxBlockContentmanagement
  class CoursesLessionContent < ApplicationRecord
    self.table_name = :courses_lession_contents

    belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :course, class_name: 'BxBlockContentmanagement::Course'
    belongs_to :lessions_content, class_name: 'BxBlockContentmanagement::LessionContent'

    before_validation :set_course, if: ->{ lessions_content.present? }


    private
    def set_course
      self.course_id = lessions_content.lession.course.id
    end
	end
end
