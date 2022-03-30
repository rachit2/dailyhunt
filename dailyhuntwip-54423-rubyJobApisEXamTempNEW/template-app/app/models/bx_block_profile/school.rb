# frozen_string_literal: true

# == Schema Information
#
# Table name: schools
#
#  id                      :bigint           not null, primary key
#  admission_process       :integer
#  course_rating           :float
#  is_featured             :boolean
#  is_popular              :boolean
#  language_of_interaction :integer
#  logo                    :string
#  median_salary           :float
#  name                    :string
#  rank                    :integer
#  school_type             :integer
#  total_fees_max          :float
#  total_fees_min          :float
#  website_url             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  board_id                :bigint           not null
#  city_id                 :bigint
#  location_id             :bigint           not null
#
# Indexes
#
#  index_schools_on_board_id     (board_id)
#  index_schools_on_city_id      (city_id)
#  index_schools_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (location_id => locations.id)
#
module BxBlockProfile
  class School < ApplicationRecord
    self.table_name = :schools

    mount_uploader :logo, ImageUploader

    belongs_to :location
    belongs_to :city
    belongs_to :board
    has_one :brochure, as: :attached_item, class_name: 'Image', dependent: :destroy
    has_many :school_standards, class_name: 'BxBlockProfile::SchoolStandard', dependent: :destroy
    has_many :standards, class_name: 'BxBlockProfile::Standard', through: :school_standards,
                         join_table: 'school_standards', foreign_key: :foreign_key

    enum school_type: ['Private', 'Private aided']
    enum language_of_interaction: %w[English Hindi Telugu Tamil Marathi Bangla Gujrati Oriya French]
    enum admission_process: %w[Ongoing Closed]

    accepts_nested_attributes_for :brochure, allow_destroy: true

    validates :name, uniqueness: true, presence: true
    after_validation :validate_city

    scope :featured_schools, -> { where(is_featured: true) }
    scope :popular_schools, -> { where(is_popular: true) }

    rails_admin do
      list do
        field :name
        field :is_featured
        field :is_popular
        field :rank
        field :total_fees_min
        field :total_fees_max
      end

      edit do
        field :name do
          label 'Name of the School'
        end
        field :logo
        field :school_type
        field :board
        field :location
        field :city
        field :website_url
        field :is_featured
        field :is_popular
        field :rank

        field :course_rating
        field :admission_process
        field :language_of_interaction
        field :median_salary
        field :total_fees_min
        field :total_fees_max
        field :standards
        field :brochure
      end
    end

    private

    def validate_city
      unless location_id == city.location_id
        errors.add(:city, "Must choose a city under #{location.name}")
        false
      end
    end
  end
end
