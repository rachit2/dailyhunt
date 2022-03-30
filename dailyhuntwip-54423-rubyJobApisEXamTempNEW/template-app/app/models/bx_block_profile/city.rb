# == Schema Information
#
# Table name: cities
#
#  id          :bigint           not null, primary key
#  address     :string
#  latitude    :float
#  logo        :string
#  longitude   :float
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint           not null
#
# Indexes
#
#  index_cities_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class BxBlockProfile::City < ApplicationRecord
  self.table_name = :cities
  mount_uploader :logo, ImageUploader
  extend Geocoder::Model::ActiveRecord
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  belongs_to :location

  validates :name, uniqueness: true, presence: true
  validates :latitude, :longitude, :location, presence: true

  rails_admin do
    list do
      field :name do
        label 'City'
      end
      field :location do
        label 'Province'
      end
      field :latitude
      field :longitude
    end

    edit do
      field :name do
        label 'City'
      end
      field :logo
      field :latitude
      field :longitude
      field :location do
        label 'Province'
      end
    end
  end
end
