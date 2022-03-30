module BxBlockContentmanagement
  class BannersController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]
    before_action :assign_banners, only: [:index]

    def index
      filter_banners
      @banners = @banners.page(params[:page]).per(params[:per_page])
      render json: BannerSerializer.new(@banners).serializable_hash, status: :ok
    end

    private

    def assign_banners
      @banners = BxBlockContentmanagement::Banner.publish.where("start_time <= ? and end_time >= ?", DateTime.current, DateTime.current).order(:rank)
      @banners = @banners.where(is_explore: params[:is_explore]) if params[:is_explore]
    end

    def filter_banners
      @banners = @banners.where(bannerable_type: BxBlockContentmanagement::Banner::TYPE_MAPPINGS[params[:bannerable_type]]) if params[:bannerable_type].present?
    end

  end
end
