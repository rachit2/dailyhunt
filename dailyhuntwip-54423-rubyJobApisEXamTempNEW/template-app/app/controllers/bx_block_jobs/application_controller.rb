module BxBlockJobs
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private
    def not_found
      render :json => {'errors' => [app_t('controllers.application.errors.record_not_found')]}, :status => :not_found
    end
  end
end
