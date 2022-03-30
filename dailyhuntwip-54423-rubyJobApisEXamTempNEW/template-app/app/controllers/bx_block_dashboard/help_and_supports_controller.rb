# frozen_string_literal: true

module BxBlockDashboard
  class HelpAndSupportsController < ApplicationController
    before_action :get_help_and_support, only: [:show]

    def index
      help_and_supports = HelpAndSupport.page(params[:page]).per(params[:per_page])
      render json: HelpAndSupportSerializer.new(help_and_supports).serializable_hash, status: :ok
    end

    def show
      render json: HelpAndSupportSerializer.new(@help_and_support).serializable_hash, status: :ok
    end

    private

    def get_help_and_support
      @help_and_support = HelpAndSupport.find(params[:id])
    end
    
  end
end

