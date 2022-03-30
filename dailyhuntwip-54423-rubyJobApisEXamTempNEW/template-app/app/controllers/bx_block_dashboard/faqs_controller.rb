# frozen_string_literal: true

module BxBlockDashboard
  class FaqsController < ApplicationController
    before_action :get_faq, only: [:show]

    def index
      faqs = Faq.page(params[:page]).per(params[:per_page])
      render json: FaqSerializer.new(faqs).serializable_hash, status: :ok
    end

    def show
      render json: FaqSerializer.new(@faq).serializable_hash, status: :ok
    end

    private

    def get_faq
      @faq = Faq.find(params[:id])
    end
    
  end
end
