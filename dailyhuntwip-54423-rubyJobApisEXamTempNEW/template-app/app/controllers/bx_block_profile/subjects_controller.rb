module BxBlockProfile
  class SubjectsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      subjects = BxBlockProfile::Subject.all.order(:rank)
      render json: BxBlockProfile::SubjectSerializer.new(subjects).serializable_hash, status: :ok
    end
  end
end
