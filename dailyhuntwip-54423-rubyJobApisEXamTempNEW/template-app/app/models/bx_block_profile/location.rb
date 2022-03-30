# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  address         :string
#  is_top_location :boolean          default(FALSE)
#  latitude        :float
#  logo            :string
#  longitude       :float
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module BxBlockProfile
	class Location < ApplicationRecord
		self.table_name = :locations
    mount_uploader :logo, ImageUploader
    has_many :cities, dependent: :destroy

    extend Geocoder::Model::ActiveRecord
    reverse_geocoded_by :latitude, :longitude
    after_validation :reverse_geocode

    validates :name, uniqueness: true, presence: true
    validates :latitude, :longitude, presence: true

    scope :top_locations, -> { where(is_top_location: true) }

    rails_admin do
      list do
        field :name do
          label 'Province'
        end
        field :is_top_location
        field :latitude
        field :longitude
      end

      edit do
        field :name do
          label 'Province'
        end
        field :logo
        field :latitude
        field :longitude
        field :is_top_location
        field :cities
      end
    end

		validates :name, uniqueness: true, presence: true
		validates :latitude, :longitude, presence: true

		scope :top_locations, -> { where(is_top_location: true) }
	end
end
