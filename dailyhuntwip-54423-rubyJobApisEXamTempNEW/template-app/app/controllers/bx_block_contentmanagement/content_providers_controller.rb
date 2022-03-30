module BxBlockContentmanagement
  class ContentProvidersController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      partners = BxBlockAdmin::AdminUser.partner_user.includes(:partner).page(params[:page]).per(params[:per_page])
      render json: BxBlockContentmanagement::ContentProviderSerializer.new(partners).serializable_hash, status: :ok
    end
  end
end
