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
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::CourseInstructor, type: :model do
  describe 'associations' do
    it { should belong_to(:course).class_name('BxBlockContentmanagement::Course') }
    # it { should belong_to(:content_provider).class_name('BxBlockAdmin::AdminUser') }
  end
end
