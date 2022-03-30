module BxBlockContentmanagement
  class AuthorsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      @author = BxBlockContentmanagement::Author.find_by(id: params[:id])
      render json: AuthorSerializer.new(@author).serializable_hash, status: :ok
    end

    def index
      content_types = BxBlockContentmanagement::Author.all.page(params[:page]).per(params[:per_page])
      render json: AuthorSerializer.new(content_types).serializable_hash, status: :ok
    end
  end
end
