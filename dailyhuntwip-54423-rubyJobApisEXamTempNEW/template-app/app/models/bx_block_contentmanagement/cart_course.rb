# == Schema Information
#
# Table name: cart_courses
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  course_cart_id :bigint           not null
#  course_id      :bigint           not null
#
# Indexes
#
#  index_cart_courses_on_course_cart_id  (course_cart_id)
#  index_cart_courses_on_course_id       (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_cart_id => course_carts.id)
#  fk_rails_...  (course_id => courses.id)
#
module BxBlockContentmanagement
  class CartCourse < ApplicationRecord
    belongs_to :course_cart
    belongs_to :course

    validates_uniqueness_of :course_id, :scope => [:course_cart_id]
  end
end
