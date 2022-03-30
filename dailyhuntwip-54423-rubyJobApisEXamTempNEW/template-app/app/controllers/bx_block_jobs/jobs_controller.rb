module BxBlockJobs
  class JobsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index,:job_type_and_experience, :locations]
    before_action :find_job, only: [:show, :apply_job]
    before_action :assign_json_web_token, only: [:index, :show]
    before_action :validate_request, only: :apply_job

    def show
      return if @job.nil?
      render json: BxBlockJobs::JobSerializer.new(@job, serialization_options).serializable_hash, status: :ok
    end

    def index
      @jobs = BxBlockJobs::Job.order(:name).page params[:page]
      filter_jobs
      @jobs = @jobs.joins(:companies).where('jobs.name ILIKE :search or companies.name ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
      job_serializer = BxBlockJobs::JobSerializer.new(@jobs)
      if !params[:with_cta]
        render json: job_serializer.serializable_hash, status: :ok
      else
        per_page = params[:per_page] || 20
        job_count_per_cta = params[:job_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/job_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        jobs_with_cta = get_jobs_with_cta(job_serializer.serializable_hash, cta_serializer.serializable_hash, job_count_per_cta)
        render json: jobs_with_cta.merge(is_next: @jobs.next_page.present?, total_pages: @jobs.total_pages), status: :ok
      end
    end

    def apply_job
      current_user.account_jobs.create!(job_id:@job.id,company_id:params[:company_id])
      render json: {
        status: { code: 200, message: 'Applied Successfully.' },
        data: BxBlockJobs::JobSerializer.new(@job,serialization_options).serializable_hash[:data]
      }
    end

    def my_jobs
      account_job_ids = current_user.account_jobs&.pluck(:job_id)
      jobs = BxBlockJobs::Job.where(id:account_job_ids)&.page params[:page]
      @total_pages = jobs&.total_pages
      render json: {
        status: { code: 200, message: 'Success.' },
        meta: { total_pages: @total_pages},
        data: BxBlockJobs::JobSerializer.new(jobs, serialization_options).serializable_hash[:data]
      }
    end

    def locations
      @locations = JobLocation.all.page params[:page]
      @total_pages = @locations.total_pages
      render json: {
        status: { code: 200, message: 'Success.' },
        meta: { total_pages: @total_pages},
        data: BxBlockJobs::JobLocationSerializer.new(@locations).serializable_hash[:data]
      }
    end

    def job_type_and_experience
      job_type= Job.job_types
      experience = Job.experiences
      date_posted = Job.date_posteds
      salaries = Job::SALARY
      render json:{job_type:job_type, experience:experience, date_posted:date_posted,salaries:salaries}, status: :ok
    end

    private

    def get_jobs_with_cta(job_serializer, cta_serializer, job_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        jobs = job_serializer[:data].in_groups_of(job_count_per_cta, false)
        data = jobs.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        job_serializer
      end
    end

    def find_job
      @job = BxBlockJobs::Job.find_by(id: params[:id])

      if @job.nil?
        render json: {
            message: "Job with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def filter_jobs
      params.each do |key, value|
        case key
        when 'trending'
          @jobs = @jobs.trending_jobs
        when 'experience'
          @jobs = @jobs.where(experience: value)
        when 'popular'
          @jobs = @jobs.popular_jobs
        when 'tag'
          @jobs = @jobs.tagged_with(value, any: true)
        when 'job_type'
          @jobs = @jobs.where(job_type:value)
        when 'location'
          @jobs = @jobs.joins(:job_locations).where(job_locations:{id:value})
        when 'salary'
          f = value.values.first.first
          l = value.values.last.last
          @jobs = @jobs.joins(:company_job_positions).where(company_job_positions:{salary:f..l})
        when 'is_recommended'
          @jobs = @jobs.where(sub_category: current_user&.sub_categories&.pluck(:id))
        when 'sub_category'
          @jobs = @jobs.where(sub_category_id:value)
        end
      end
    end

    private

    def validate_request
      return (render json:{errors:'Please enter valid company_id'}, status: :not_found) unless params[:company_id]
      return (render json:{errors: "This Job not found in company id - #{params[:company_id]}"}, status: :not_found) unless @job.companies&.pluck(:id)&.include? params[:company_id].to_i
      return (render json: {errors: 'Already Applied'}, status: :unprocessable_entity) if @job.account_jobs.where(account_id:current_user.id, company_id:params[:company_id])&.present?
    end

    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id, current_user:current_user}
      options
    end

  end
end
