module BxBlockProfile
  class DegreesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      degrees = BxBlockProfile::Degree.all.order(:rank)
      render json: BxBlockProfile::DegreeSerializer.new(degrees).serializable_hash, status: :ok
    end
  end
end
