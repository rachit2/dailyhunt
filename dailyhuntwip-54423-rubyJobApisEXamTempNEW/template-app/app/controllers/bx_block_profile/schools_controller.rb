# frozen_string_literal: true

module BxBlockProfile
  class SchoolsController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[index show]

    before_action :find_schools, only: %i[index]
    before_action :find_school, only: %i[show]

    def index
      @schools = filter_by_search(params[:search]) if params[:search].present?
      filter_schools
      @schools = @schools.page(params[:page]).per(params[:per_page])
      school_serializer = BxBlockProfile::SchoolSerializer.new(@schools)
      if !params[:with_cta]
        render json: school_serializer.serializable_hash, status: :ok
      else
        per_page = params[:per_page] || 20
        school_count_per_cta = params[:school_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/school_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        schools_with_cta = get_schools_with_cta(school_serializer.serializable_hash, cta_serializer.serializable_hash, school_count_per_cta)
        render json: schools_with_cta.merge(is_next: @schools.next_page.present?, total_pages: @schools.total_pages), status: :ok
      end
    end

    def show
      return if @school.nil?
      render json: BxBlockProfile::SchoolSerializer.new(@school, serialization_options)
                                                   .serializable_hash,
             status: :ok
    end

    def total_fees_list
      total_fees_list = BxBlockProfile::TotalFee.active
      render json: BxBlockProfile::TotalFeesSerializer.new(total_fees_list).serializable_hash,
        status: :ok
    end

    private

    def find_school
      @school = BxBlockProfile::School.find_by(id: params[:id])

      if @school.nil?
        render json: {
          message: "School with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def find_schools
      @schools = BxBlockProfile::School.includes(:location, :city, :standards, :board).order(:rank)
    end

    def filter_schools
      params.each do |key, value|
        case key
        when 'featured'
          @schools = @schools.featured_schools
        when 'popular'
          @schools = @schools.popular_schools
        when 'location'
          @schools = @schools.where(locations: { id: value })
        when 'city'
          @schools = @schools.where(cities: { id: value })
        when 'total_fees'
          @schools = filter_by_total_fees(value.values)
        when 'standards'
          @schools = @schools.where(standards: { id: value })
        when 'boards'
          @schools = @schools.where(boards: { id: value })
        when 'school_types'
          @schools = @schools.where(school_type: value)
        when 'languages'
          @schools = @schools.where(language_of_interaction: value)
        when 'admission_processes'
          @schools = @schools.where(admission_process: value)
        when 'locations'
          @schools = @schools.where(locations: { id: value })
        when 'distance_range'
          @schools = fetch_schools_by_distance_range(value)
        end
      end
    end

    def filter_by_search(search)
      @schools.where('schools.name ILIKE :search OR locations.name ILIKE :search OR cities.name ILIKE :search OR boards.name ILIKE :search OR standards.name ILIKE :search', search: "%#{search}%").references(
        :location, :city, :standards, :board
      )
    end

    def filter_by_total_fees(price_ranges)
      query_string = []
      price_ranges.each do |a|
        query_string << (price_ranges.last == a ? " (total_fees_min > #{a.first} AND total_fees_max < #{a.last})" : " (total_fees_min > #{a.first} AND total_fees_max < #{a.last}) OR")
      end
      @schools.where(query_string.join)
    end

    def fetch_schools_by_distance_range(range)
      coordinates_array = @schools.includes(:location).pluck(%i[locations.latitude locations.longitude])
      locations_ids = coordinates_array.inject([]) do |arr, coordinate|
        arr << BxBlockProfile::Location.near([coordinate[0], coordinate[1]], range.to_i, units: :km, order: false).ids
        arr.flatten.uniq
      end
      BxBlockProfile::School.where(location_id: locations_ids)
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end


    def get_schools_with_cta(school_serializer, cta_serializer, school_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        schools = school_serializer[:data].in_groups_of(school_count_per_cta, false)
        data = schools.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        school_serializer
      end
    end

  end
end
