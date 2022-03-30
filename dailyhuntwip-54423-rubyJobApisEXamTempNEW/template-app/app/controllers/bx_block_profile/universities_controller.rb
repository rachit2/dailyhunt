# frozen_string_literal: true

module BxBlockProfile
  class UniversitiesController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[index show]

    before_action :find_universities, only: %i[index]
    before_action :find_university, only: %i[show]

    def create
      university = BxBlockProfile::University.new(university_params)

      if university.save
        render json: BxBlockProfile::UniversitySerializer.new(university, serialization_options)
                                                         .serializable_hash,
               status: :created
      else
        render json: BxBlockProfile::ErrorSerializer.new(university).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def show
      return if @university.nil?

      render json: BxBlockProfile::UniversitySerializer.new(@university, serialization_options)
                                                       .serializable_hash,
             status: :ok
    end

    def index
      filter_universities
      @universities = @universities.page(params[:page]).per(params[:per_page])

      render json: BxBlockProfile::UniversitySerializer.new(@universities).serializable_hash, status: :ok
    end

    private

    def university_params
      params.require(:data).permit(:name, :is_featured, :logo, :location_id)
    end

    def find_universities
      @universities = BxBlockProfile::University.includes(:location, degrees: [:specializations])
    end

    def find_university
      @university = BxBlockProfile::University.find_by(id: params[:id])

      if @university.nil?
        render json: {
          message: "University with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end

    def filter_universities
      params.each do |key, value|
        case key
        when 'featured'
          @universities = @universities.featured_universities
        when 'location'
          @universities = @universities.where(locations: { id: value })
        when 'total_fees'
          @universities = filter_by_total_fees(value.values)
        when 'courses'
          @universities = @universities.where(degrees: { id: value })
        when 'specialization'
          @universities = @universities.where(specializations: { id: value })
        end
      end
    end

    def filter_by_total_fees(price_ranges)
      query_string = []
      price_ranges.each do |a|
        query_string << (price_ranges.last == a ? " (total_fees_min > #{a.first} AND total_fees_max < #{a.last})" : " (total_fees_min > #{a.first} AND total_fees_max < #{a.last}) OR")
      end
      @universities.where(query_string.join)
    end
  end
end
