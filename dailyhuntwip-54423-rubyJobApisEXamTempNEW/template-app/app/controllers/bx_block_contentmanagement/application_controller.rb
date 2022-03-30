module BxBlockContentmanagement
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def check_current_partner
      admin_user_id = @token.id
      @admin_user = BxBlockAdmin::AdminUser.partner_user.find_by(id: admin_user_id)
      unless @admin_user.present?
        render json: {error: 'please login with partner'}, status: 404
      end
    end

    def not_found
      render :json => {'errors' => [app_t('controllers.application.errors.record_not_found')]}, :status => :not_found
    end
  end
end
