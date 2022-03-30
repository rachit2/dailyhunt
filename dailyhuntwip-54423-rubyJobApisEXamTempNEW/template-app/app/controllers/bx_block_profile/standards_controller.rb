module BxBlockProfile
  class StandardsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      standards = BxBlockProfile::Standard.all.order(:rank)
      render json: BxBlockProfile::StandardSerializer.new(standards).serializable_hash, status: :ok
    end
  end
end
