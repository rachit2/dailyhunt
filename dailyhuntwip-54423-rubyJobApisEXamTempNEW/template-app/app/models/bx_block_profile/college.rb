# == Schema Information
#
# Table name: colleges
#
#  id                :bigint           not null, primary key
#  admission_process :integer
#  college_type      :integer
#  course_rating     :float
#  is_featured       :boolean          default(FALSE)
#  is_others         :boolean          default(FALSE)
#  is_popular        :boolean          default(FALSE)
#  logo              :string
#  median_salary     :float
#  name              :string
#  rank              :integer
#  total_fees_max    :float
#  total_fees_min    :float
#  website_url       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  city_id           :bigint
#  location_id       :bigint           not null
#  sub_category_id   :integer
#  university_id     :bigint           not null
#
# Indexes
#
#  index_colleges_on_city_id        (city_id)
#  index_colleges_on_location_id    (location_id)
#  index_colleges_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (university_id => universities.id)
#
module BxBlockProfile
  class College < ApplicationRecord
    self.table_name = :colleges

    mount_uploader :logo, ImageUploader

    validates :name, uniqueness: true, presence:true
    has_many :profiles, dependent: :nullify
    has_many :education_level_profiles, dependent: :nullify

    belongs_to :location
    belongs_to :city
  	belongs_to :university
  	has_many :college_and_degrees, class_name: "BxBlockProfile::CollegeAndDegree", dependent: :destroy
  	has_many :degrees, class_name: "BxBlockProfile::Degree", through: :college_and_degrees, join_table: "college_and_degrees", foreign_key: :foreign_key
    has_and_belongs_to_many :specializations, class_name: "BxBlockProfile::Specialization"
    has_and_belongs_to_many :courses, class_name: "BxBlockContentmanagement::Course"

    belongs_to :sub_category, class_name:"BxBlockCategories::SubCategory", optional: true

    has_one :brochure, as: :attached_item, class_name: "Image", dependent: :destroy
    enum admission_process: %w[Ongoing Closed]
    after_validation :validate_city
    # has_many :specializations
    enum college_type: ['Private', 'Private aided']
    scope :featured_colleges, -> { where(is_featured: true) }
    scope :popular_colleges, -> { where(is_popular: true) }

	  accepts_nested_attributes_for :brochure, allow_destroy: true

    private

    def validate_city
      unless location_id == city.location_id
        errors.add(:city, "Must choose a city under #{location.name}")
        false
      end
    end
  end
end
