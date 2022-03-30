# == Schema Information
#
# Table name: universities
#
#  id             :bigint           not null, primary key
#  course_rating  :float
#  is_featured    :boolean
#  logo           :string
#  median_salary  :float
#  name           :string
#  total_fees_max :float
#  total_fees_min :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location_id    :bigint           not null
#
# Indexes
#
#  index_universities_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
module BxBlockProfile
	class University < ApplicationRecord
		self.table_name = :universities
    
		mount_uploader :logo, ImageUploader

		belongs_to :location
    has_one :brochure, as: :attached_item, class_name: "Image", dependent: :destroy
    has_many :university_and_degrees, class_name: "BxBlockProfile::UniversityAndDegree", dependent: :destroy
    has_many :degrees, class_name: "BxBlockProfile::Degree", through: :university_and_degrees, join_table: "university_and_degrees", foreign_key: :foreign_key


    validates :name, presence: true
    validates :name, :uniqueness => { :scope => [:location_id], message: "University is already created." }

		scope :featured_universities, -> { where(is_featured: true) }

    accepts_nested_attributes_for :brochure, allow_destroy: true
	end
end
