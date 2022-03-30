# frozen_string_literal: true

module BxBlockProfile
  class LocationSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :latitude, :longitude, :logo, :is_top_location, :cities, :created_at, :updated_at

    attributes :cities do |object|
      CitySerializer.new(object.cities) if object.cities.present?
    end

    attribute :count do |object, params|
      count = 0
      if params[:current_page].present?
        count = fetch_colleges_count(object) if params[:current_page] =="colleges"
        count = fetch_schools_count(object) if params[:current_page] == "schools"
        count = fetch_schools_count(object) + fetch_colleges_count(object) if params[:current_page]=='all'
      end
      count
    end

    attribute :logo do |object|
      object.logo.url if object.logo&.present?
    end


    class << self
      private

      def fetch_colleges_count(record)
        BxBlockProfile::College.where(location_id: record.id).size
      end

      def fetch_schools_count(record)
        BxBlockProfile::School.where(location_id: record.id).size
      end
    end
  end
end
