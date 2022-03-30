class BxBlockJobs::JobCategorySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :companies, :jobs_count, :logo

  attribute :companies, if: Proc.new { |record, params|
    params
  } do |object, params|
    ob_companies = params[:companies].present? ? params[:companies] : []
    BxBlockCompanies::CompanySerializer.new(ob_companies).serializable_hash[:data]
  end

  attributes :logo do |object|
    object.logo_url
  end

  attribute :jobs_count do |object|
    object.jobs&.count
  end

end
