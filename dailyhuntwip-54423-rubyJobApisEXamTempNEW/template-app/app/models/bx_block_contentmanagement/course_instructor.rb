# == Schema Information
#
# Table name: course_instructors
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :bigint
#  instructor_id :bigint
#
# Indexes
#
#  index_course_instructors_on_course_id      (course_id)
#  index_course_instructors_on_instructor_id  (instructor_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (instructor_id => instructors.id)
#
module BxBlockContentmanagement
	class CourseInstructor < ApplicationRecord
		self.table_name = :course_instructors

		belongs_to :course
		belongs_to :instructor
	end
end
