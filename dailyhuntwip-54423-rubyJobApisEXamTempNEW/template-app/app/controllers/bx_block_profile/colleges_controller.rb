# frozen_string_literal: true

module BxBlockProfile
  class CollegesController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[index show college_school_search]
    before_action :find_colleges, only: %i[index sub_categories college_school_search]
    before_action :find_college, only: %i[show]
    before_action :find_schools, only: %i[college_school_search]

    def college_school_search
      filter_combine_search(params[:search]) if params[:search].present?
      colleges = BxBlockProfile::CollegeSerializer.new(@colleges).serializable_hash
      schools = BxBlockProfile::SchoolSerializer.new(@schools).serializable_hash
      data = schools[:data]&.push(colleges[:data])&.flatten
      render json: {data:data}, status: :ok
    end

    def index
      @colleges = filter_by_search(params[:search]) if params[:search].present?

      filter_colleges
      @colleges = @colleges.page(params[:page]).per(params[:per_page])
      college_serializer = BxBlockProfile::CollegeSerializer.new(@colleges)

      if !params[:with_cta]
        render json: college_serializer.serializable_hash, status: :ok
      else
        per_page = params[:per_page] || 20
        college_count_per_cta = params[:college_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/college_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        colleges_with_cta = get_colleges_with_cta(college_serializer.serializable_hash, cta_serializer.serializable_hash, college_count_per_cta)
        render json: colleges_with_cta.merge(is_next: @colleges.next_page.present?, total_pages: @colleges.total_pages), status: :ok
      end
    end

    def show
      return if @college.nil?
      render json: BxBlockProfile::CollegeSerializer.new(@college, serialization_options)
                                                    .serializable_hash,
             status: :ok
    end

    def sub_categories
      @sub_categories = BxBlockCategories::SubCategory.joins(:colleges).where.not(colleges:{sub_category_id:nil})&.uniq
      render json: BxBlockCategories::SubCategorySerializer.new(@sub_categories, params:{categories:true}).serializable_hash, status: :ok
    end

    def specializations
      @specializations = Specialization.where.not(college_id:nil)&.uniq
      render json: SpecializationSerializer.new(@specializations).serializable_hash, status: :ok
    end

    private

    def find_college
      @college = BxBlockProfile::College.find_by(id: params[:id])

      if @college.nil?
        render json: {
          message: "College with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def find_colleges
      @colleges = BxBlockProfile::College.includes(:location, :city, :university,
                                                   degrees: [:specializations]).order(:rank)
    end

    def find_schools
      @schools = BxBlockProfile::School.includes(:location, :city, :standards, :board).order(:rank)
    end

    def filter_by_search(search)
      @colleges.where('colleges.name ILIKE :search OR locations.name ILIKE :search OR cities.name ILIKE :search OR universities.name ILIKE :search OR degrees.name ILIKE :search OR specializations.name ILIKE :search', search: "%#{search}%").references(
        :location, :city, :university, degrees: [:specializations]
      )
    end

    def filter_combine_search(search)
      @colleges = filter_by_search(search)
      @schools = @schools.where('schools.name ILIKE :search OR locations.name ILIKE :search OR cities.name ILIKE :search OR boards.name ILIKE :search OR standards.name ILIKE :search', search: "%#{search}%").references(
        :location, :city, :standards, :board
      )
    end

    def filter_colleges
      params.each do |key, value|
        case key
        when 'featured'
          @colleges = @colleges.featured_colleges
        when 'popular'
          @colleges = @colleges.popular_colleges
        when 'location'
          @colleges = @colleges.where(locations: { id: value })
        when 'city'
          @colleges = @colleges.where(cities: { id: value })
        when 'total_fees'
          @colleges = filter_by_total_fees(value.values)
        when 'college_types'
          @colleges = @colleges.where(college_type: value)
        when 'degrees'
          @colleges = @colleges.where(degrees: { id: value })
        when 'specialization'
          @colleges = @colleges.joins(:specializations).where(specializations: { id: value })
        when 'courses'
          @colleges = @colleges.joins(:courses).where(courses: { id: value })
        when 'admission_processes'
          @colleges = @colleges.where(admission_process: value)
        when 'category'
          @colleges = @colleges.joins(sub_category: :categories)&.where(categories:{id:value})
        when 'sub_category'
          @colleges = @colleges.where(sub_category_id:value)
        end
      end
    end

    def filter_by_total_fees(price_ranges)
      query_string = []
      price_ranges.each do |a|
        query_string << (price_ranges.last == a ? " (total_fees_min > #{a.first} AND total_fees_max < #{a.last})" : " (total_fees_min > #{a.first} AND total_fees_max < #{a.last}) OR")
      end
      @colleges.where(query_string.join)
    end

    def get_colleges_with_cta(college_serializer, cta_serializer, college_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        colleges = college_serializer[:data].in_groups_of(college_count_per_cta, false)
        data = colleges.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        college_serializer
      end
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end
