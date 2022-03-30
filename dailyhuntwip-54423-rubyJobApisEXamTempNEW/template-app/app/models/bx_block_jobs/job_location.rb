# == Schema Information
#
# Table name: job_locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  city       :string
#  country    :string
#  latitude   :float
#  longitude  :float
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BxBlockJobs::JobLocation < ApplicationRecord
  self.table_name = :job_locations
  extend Geocoder::Model::ActiveRecord
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  has_many :job_places
  has_many :jobs, through: :job_places
  validates :latitude, :longitude, :city, :state,:country, presence: true

  def companies_d
    jobs.map{|a|a.companies}
  end

  rails_admin do
    configure :contentable do
      label 'Headline'
    end
    field :latitude
    field :longitude
    field :city
    field :state
    field :country
    field :jobs
  end
end
