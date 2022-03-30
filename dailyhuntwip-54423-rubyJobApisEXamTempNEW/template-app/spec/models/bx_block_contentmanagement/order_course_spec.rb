# == Schema Information
#
# Table name: order_courses
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  course_id       :bigint           not null
#  course_order_id :bigint           not null
#
# Indexes
#
#  index_order_courses_on_course_id        (course_id)
#  index_order_courses_on_course_order_id  (course_order_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (course_order_id => course_orders.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::OrderCourse, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
  end
end
