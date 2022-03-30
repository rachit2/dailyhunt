module BxBlockExperts
  class AccountExpertsController < ApplicationController

    before_action :assign_json_web_token, only: %i[index show]
    before_action :find_account_experts, only: %i[index]
    before_action :find_account_expert, only: %i[show unfollow]
    before_action :find_career_expert, only: :destroy
    # before_action :validate_request, only: :book_or_follow

    def index
      @experts = @experts&.page(params[:page])&.per(params[:per_page])
      render json: BxBlockExperts::AccountExpertSerializer.new(@experts,serialization_options).serializable_hash, status: :ok
    end

    def show
      return if @expert.nil?
      render json: BxBlockExperts::AccountExpertSerializer.new(@expert, serialization_options)
                                                 .serializable_hash,
             status: :ok
    end

    def destroy
      return if @expert.nil?
      mode = params[:mode] || "Follow"
      experts = @expert.account_experts.where(account_id:current_user.id, mode: mode)
      if experts.destroy_all
        render json:{message:"un#{mode}ed Success"}, status: :ok
      else
        render json: {
          message: "Something went wrong"
        }, status: :not_found
      end
    end

    private

    def find_career_expert
      @expert = BxBlockExperts::CareerExpert.find_by(id: params[:id])
      if @expert.nil?
        render json: {
          message: "CareerExpert with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def find_account_expert
      @expert = current_user.account_experts&.find_by(id: params[:id])

      if @expert.nil?
        render json: {
          message: "AccountExpert with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def find_account_experts
      @experts = current_user.account_experts
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port, current_user_id: (current_user&.id) } }
    end

  end
end
