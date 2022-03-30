class BxBlockCompanies::CompanySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :about, :positions, :vacant_position_count, :trending, :popular, :tags, :company_addresses, :logo, :bookmark

    attributes :positions do |object, params|
      jobs = params[:job]&.present? ? params[:job] : object.company_job_positions&.vacant_positions
      jobs = params[:filter_jobs] if params[:show_filter].present?
      BxBlockJobs::JobSerializer.new(jobs, params:{company_id:object.id, current_user_id:params[:current_user_id], current_user:params[:current_user], company:object}).serializable_hash[:data]
    end

    attributes :company_addresses do |object|
      BxBlockCompanies::CompanyAddressesSerializer.new(object.company_addresses).serializable_hash[:data]
    end

    attributes :vacant_position_count do |object|
      object.company_job_positions&.vacant_positions&.count
    end

    attributes :logo do |object|
      object.logo_url
    end

    attribute :bookmark do |object, params|
      params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id]) ? true : false
    end

    class << self
      private
      def current_user_bookmark(record, current_user_id)
        record.bookmarks.where(account_id: current_user_id).present?
      end
    end

end
