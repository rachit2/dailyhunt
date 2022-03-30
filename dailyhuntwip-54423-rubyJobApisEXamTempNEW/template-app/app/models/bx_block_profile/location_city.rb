# == Schema Information
#
# Table name: location_cities
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city_id     :bigint           not null
#  location_id :bigint           not null
#
# Indexes
#
#  index_location_cities_on_city_id      (city_id)
#  index_location_cities_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (location_id => locations.id)
#
class BxBlockProfile::LocationCity < ApplicationRecord
  self.table_name = :location_cities

  belongs_to :location
  belongs_to :city
end
