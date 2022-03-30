module BxBlockJobs
  class JobCategoriesController < ApplicationController

    include BuilderJsonWebToken::JsonWebTokenValidation
    skip_before_action :validate_json_web_token, only: [:show, :index]
    before_action :find_jcategory, only: [:show]

    def show
      return if @jcategory.nil?
      @companies = @jcategory.companies
      filter_companies
      render json: BxBlockJobs::JobCategorySerializer.new(@jcategory,params:{companies:@companies&.uniq}).serializable_hash, status: :ok
    end

    def index
      @jcategories = BxBlockJobs::JobCategory.order(:name).page params[:page]
      @total_pages = @jcategories.total_pages
      jcategory_serializer = BxBlockJobs::JobCategorySerializer.new(@jcategories)
      if !params[:with_cta]
        render json: {
          status: { code: 200, message: 'Success.' },
          meta: { total_pages: @total_pages},
          data: jcategory_serializer.serializable_hash[:data]
        }
      else
        per_page = params[:per_page] || 20
        jcategory_count_per_cta = params[:jcategory_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/jcategory_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        jcategories_with_cta = get_jcategories_with_cta(jcategory_serializer.serializable_hash, cta_serializer.serializable_hash, jcategory_count_per_cta)
        render json: jcategories_with_cta.merge(is_next: @jcategories.next_page.present?, total_pages: @jcategories.total_pages), status: :ok
      end
    end

    private

    def get_jcategories_with_cta(jcategory_serializer, cta_serializer, jcategory_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        jcategories = jcategory_serializer[:data].in_groups_of(jcategory_count_per_cta, false)
        data = jcategories.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        jcategory_serializer
      end
    end

    def return_date_query(posted_date)
      test_a=[]
      posted_date.each do |pd|
        case pd
        when "past_month"
          # where(created_at:((Date.today-1.month).beginning_of_month..(Date.today-1.month).end_of_month))
          test_a << ((Date.today-1.month).beginning_of_month..(Date.today-1.month).end_of_month)
        when "past_week"
          # where(created_at:((Date.today-1.week).beginning_of_week..(Date.today-1.week).end_of_week))
          test_a << ((Date.today-1.week).beginning_of_week..(Date.today-1.week).end_of_week)
        when "last_24_hours"
          # where(created_at:(Date.today.beginning_of_day..Date.today.end_of_day))
          test_a << ((Date.today.beginning_of_day..Date.today.end_of_day))
        end
      end
      test_a
    end

    def filter_salary(values)
      test_a = []
      values.each do |value|
        case value
        when "0-3 lakhs"
          test_a << (0..300000)
        when "3-6 lakhs"
          test_a << (300000..600000)
        when "6-10 lakhs"
          test_a << (600000..1000000)
        when "10-15 lakhs"
          test_a << (1000000..1500000)
        when "15-30 lakhs"
          test_a << (1500000..3000000)
        when "30-50 lakhs"
          test_a << (3000000..5000000)
        end
      end
      test_a
    end

    def filter_companies
      params.each do |key, value|
        case key
        when 'trending'
          @companies = @companies.trending_companies
        when 'experience'
          @companies = @companies.joins(:jobs).where(jobs:{experience:value})
        when 'popular'
          @companies = @companies.popular_companies
        when 'tag'
          @companies = @companies.tagged_with(value, any: true)
        when 'job_type'
          @companies = @companies.joins(:jobs).where(jobs:{job_type:value})
        when 'location'
          @companies = @companies.joins(jobs: :job_locations).where(job_locations:{id:value})
        when 'salary'
          f = value.values.first.first
          l = value.values.last.last
          @companies = @companies.joins(:company_job_positions).where(company_job_positions:{salary:f..l})
        when 'salary_id'
          @companies = @companies.joins(:company_job_positions).where(company_job_positions:{salary:filter_salary(value)})
        when 'city'
          @companies = @companies.joins(jobs: :job_locations).where(job_locations:{city:value})
        when 'state'
          @companies = @companies.joins(jobs: :job_locations).where(job_locations:{city:value})
        when 'sub_category'
          @companies = @companies.joins(:jobs).where(jobs:{sub_category_id:value})
        when 'date_posted'
          @companies = @companies.joins(:company_job_positions).where(company_job_positions:{created_at:return_date_query(value)})
        when 'search'
          search = "%#{value.to_s.downcase}%"
          @companies = @companies.joins(:jobs).where("lower(jobs.name) LIKE ? or lower(companies.name) LIKE ?", search, search)
        end
      end
    end

    def find_jcategory
      @jcategory = BxBlockJobs::JobCategory.find_by(id: params[:id])
      if @jcategory.nil?
        render json: {
            message: "Job with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

  end

end
