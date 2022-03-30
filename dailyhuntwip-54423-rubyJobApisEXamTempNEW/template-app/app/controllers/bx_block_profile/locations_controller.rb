# frozen_string_literal: true

module BxBlockProfile
  class LocationsController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[index show]

    before_action :find_locations, only: %i[index]
    before_action :find_location, only: %i[show]

    def create
      location = BxBlockProfile::Location.new(location_params)

      if location.save
        render json: BxBlockProfile::LocationSerializer.new(location, serialization_options)
                                                       .serializable_hash,
               status: :created
      else
        render json: BxBlockProfile::ErrorSerializer.new(location).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def show
      return if @location.nil?

      render json: BxBlockProfile::LocationSerializer.new(@location, serialization_options)
                                                     .serializable_hash,
             status: :ok
    end

    def index
      current_page_data = params['current_page'].present? ? params['current_page'] : 'all'
      if params['top_locations'].present? && params['top_locations'] == 'true'
        if params['latitude'].present? && params['longitude'].present?
          top_locations_with_coordinates
          serialization_options = { params: { top_locations: true, current_page: current_page_data } }
        else
          @locations = @locations.top_locations.limit(10)
          serialization_options = { params: { top_locations: false, current_page:current_page_data } }
        end
      else
        serialization_options = { params: { top_locations: false, current_page: current_page_data } }
      end
      @locations = @locations.joins(:cities).where("lower(locations.name) LIKE :search OR  lower(cities.name)  LIKE :search", search: "%#{params[:name].downcase}%") if params[:name].present?
      render json: BxBlockProfile::LocationSerializer.new(@locations, serialization_options).serializable_hash,
             status: :ok
    end

    private

    def location_params
      params.require(:data).permit(:name, :latitude, :longitude, :is_top_location)
    end


    def find_locations
      @locations = BxBlockProfile::Location.all
    end

    def find_location
      @location = BxBlockProfile::Location.find_by(id: params[:id])

      if @location.nil?
        render json: {
          message: "Location with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def top_locations_with_coordinates
      @locations = @locations.top_locations.near([params['latitude'], params['longitude']], 60, units: :km,
                                                                                                order: false).limit(10)

      if @locations.size < 10
        locations = BxBlockProfile::Location.top_locations.where.not(id: @locations.pluck(:id)).limit(10 - @locations.size)
        @locations += locations
      end
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end
