class BxBlockJobs::JobSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :salary, :description, :trending, :popular, :requirement, :job_type, :experience, :locations, :companies, :created_at, :sub_category, :bookmark, :applied_job, :job_category

  attribute :locations do |object|
    BxBlockJobs::JobLocationSerializer.new(object.job_locations).serializable_hash[:data]
  end

  attribute :applied_job do |object, params|
    params && params[:current_user] && params[:company] && current_user_job(object, params[:current_user], params[:company]) ? true : false
  end

  attribute :salary, if: Proc.new { |record, params|
    params && params[:company_id]
  } do |object, params|
    object.company_job_positions&.where(company_id:params[:company_id])&.first&.salary
  end

  attribute :bookmark do |object, params|
    params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id]) ? true : false
  end

  class << self
    private
    def current_user_bookmark(record, current_user_id)
      record.bookmarks.where(account_id: current_user_id).present?
    end

    def current_user_job(record, current_user, company)
      current_user.account_jobs&.pluck(:job_id,:company_id).include? [record.id.to_s,company.id.to_s]
    end

  end

end
