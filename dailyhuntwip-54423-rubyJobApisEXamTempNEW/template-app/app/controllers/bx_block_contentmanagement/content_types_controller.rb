module BxBlockContentmanagement
  class ContentTypesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      content_types = BxBlockContentmanagement::ContentType.all.order(:rank).page(params[:page]).per(params[:per_page])
      render json: ContentTypeSerializer.new(content_types).serializable_hash, status: :ok
    end
  end
end
