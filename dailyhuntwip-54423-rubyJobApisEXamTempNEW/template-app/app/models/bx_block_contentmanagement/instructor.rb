# == Schema Information
#
# Table name: instructors
#
#  id          :bigint           not null, primary key
#  bio         :string
#  designation :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
	class Instructor < ApplicationRecord
		self.table_name = :instructors
		has_many :course_instructors, class_name: 'BxBlockContentmanagement::CourseInstructor', dependent: :destroy
		has_many :courses, class_name: "BxBlockContentmanagement::Course", through: :course_instructors
    validates :name, :bio, presence: true
    has_one :image, as: :attached_item, dependent: :destroy

    accepts_nested_attributes_for :image, allow_destroy: true

	end
end
