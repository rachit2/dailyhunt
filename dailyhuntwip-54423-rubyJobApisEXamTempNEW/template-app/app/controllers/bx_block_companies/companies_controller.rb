module BxBlockCompanies
  class CompaniesController < ApplicationController

    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :assign_json_web_token, only: [:index, :show]
    before_action :find_company, only: [:show, :jobs]
    before_action :find_companies, only: %i[index]
    before_action :find_job, only: :jobs

    def index
      filter_companies
      @companies = @companies.page(params[:page]).per(params[:per_page])
      @total_pages = @companies.total_pages
      company_serializer= BxBlockCompanies::CompanySerializer.new(@companies&.uniq,serialization_options)
      if !params[:with_cta]
        render json: {
          status: { code: 200, message: 'Success.' },
          meta: { total_pages: @total_pages},
          data: company_serializer.serializable_hash[:data]
        }
      else
        per_page = params[:per_page] || 20
        company_count_per_cta = params[:company_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/company_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        companies_with_cta = get_companies_with_cta(company_serializer.serializable_hash, cta_serializer.serializable_hash, company_count_per_cta)
        render json: companies_with_cta.merge(is_next: @companies.next_page.present?, total_pages: @companies.total_pages), status: :ok
      end
    end

    def show
      return if @company.nil?
      @jobs = @company.jobs
      filter_jobs
      render json: BxBlockCompanies::CompanySerializer.new(@company,filter_job_options).serializable_hash, status: :ok
    end

    def jobs
      return if @company.nil?
      render json: BxBlockCompanies::CompanySerializer.new(@company,job_options).serializable_hash, status: :ok
    end

    private

    def get_companies_with_cta(company_serializer, cta_serializer, company_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        companies = company_serializer[:data].in_groups_of(company_count_per_cta, false)
        data = companies.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        company_serializer
      end
    end


    def filter_jobs
      params.each do |key, value|
        case key
        when 'trending'
          @jobs = @jobs.trending_jobs
        when 'experience'
          @jobs = @jobs.where(experience:value)
        when 'popular'
          @jobs = @jobs.popular_jobs
        when 'tag'
          @jobs = @jobs.tagged_with(value, any: true)
        when 'job_type'
          @jobs = @jobs.where(jobs:{job_type:value})
        when 'location'
          @jobs = @jobs.joins(:job_locations).where(job_locations:{id:value})
        when 'salary'
          f = value.values.first.first
          l = value.values.last.last
          @jobs = @jobs.joins(:company_job_positions).where(company_job_positions:{salary:f..l})
        when 'salary_id'
          @jobs = @jobs.joins(:company_job_positions).where(company_job_positions:{salary:filter_salary(value)})
        when 'city'
          @jobs = @jobs.joins(:job_locations).where(job_locations:{city:value})
        when 'state'
          @jobs = @jobs.joins(:job_locations).where(job_locations:{city:value})
        when 'sub_category'
          @jobs = @jobs.where(sub_category_id:value)
        when 'date_posted'
          @jobs = @jobs.joins(:company_job_positions).where(company_job_positions:{created_at:return_date_query(value)})
        when 'search'
          search = "%#{value.to_s.downcase}%"
          @jobs = @jobs.where("lower(name) LIKE ?", search)
        when 'job_category'
          @jobs = @jobs.where(job_category_id:value)
        end
      end

    end

    def find_companies
      @companies = BxBlockCompany::Company.order(:name)
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
        when 'job_category'
          @companies = @companies.joins(:jobs).where(jobs:{job_category_id:value})
        end
      end
    end

    def filter_job_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id), current_user:current_user, filter_jobs:@jobs, show_filter:true }
      options
    end

    def job_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id), current_user:current_user, job:@job }
      options
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id), current_user:current_user }
      options
    end

    def find_job
      @job = @company.jobs.find(params[:job_id])
    end

    def find_company
      @company = BxBlockCompany::Company.find_by(id: params[:id])
      if @company.nil?
        render json: {
            message: "Job with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end
  end

end
