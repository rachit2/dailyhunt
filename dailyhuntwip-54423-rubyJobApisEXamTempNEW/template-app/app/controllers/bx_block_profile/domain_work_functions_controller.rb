module BxBlockProfile
  class DomainWorkFunctionsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      domain_work_functions = BxBlockProfile::DomainWorkFunction.all.order(:rank)
      render json: BxBlockProfile::DomainWorkFunctionSerializer.new(domain_work_functions).serializable_hash, status: :ok
    end
  end
end
