  module BxBlockProfile
  class SpecializationsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      specializations = BxBlockProfile::Specialization.all.order(:rank)
      specializations = specializations.where(degree_id: params[:degree_id]) if params[:degree_id].present?
      specializations = specializations.where(higher_education_level_id: params[:higher_education_level_id]) if params[:higher_education_level_id].present?
      render json: BxBlockProfile::SpecializationSerializer.new(specializations).serializable_hash, status: :ok
    end
  end
end
