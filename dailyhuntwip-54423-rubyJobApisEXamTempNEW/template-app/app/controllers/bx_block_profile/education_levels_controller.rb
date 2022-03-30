module BxBlockProfile
  class EducationLevelsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      education_levels = BxBlockProfile::EducationLevel.all.order(:rank)
      render json: BxBlockProfile::EducationLevelSerializer.new(education_levels).serializable_hash, status: :ok
    end
  end
end
