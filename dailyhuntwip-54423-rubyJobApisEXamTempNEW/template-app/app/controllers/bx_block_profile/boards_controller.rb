module BxBlockProfile
  class BoardsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      boards = BxBlockProfile::Board.all.order(:rank)
      render json: BxBlockProfile::BoardSerializer.new(boards).serializable_hash, status: :ok
    end
  end
end
