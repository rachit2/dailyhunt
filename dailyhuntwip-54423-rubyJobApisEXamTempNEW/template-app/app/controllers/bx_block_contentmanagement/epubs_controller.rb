module BxBlockContentmanagement
  class EpubsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index, :home_epubs, :show]

    def index
      filter_epub
      @epubs = @epubs.page(params[:page]).per(params[:per_page])
      render json: EpubSerializer.new(@epubs, serialization_options).serializable_hash, status: :ok
    end

    def home_epubs
      epubs = Epub.joins(:contentable)
      data =  [
            {title: 'popular', list: EpubSerializer.new(epubs.where(contents: {is_popular: true}), serialization_options)},
            {title: 'trending', list: EpubSerializer.new(epubs.where(contents: {is_trending: true}), serialization_options)},
            {title: 'recommended_epubs', list: []}
          ]
      render :json => {data: data}, status: :ok
    end

    def show
      epub = BxBlockContentmanagement::Epub.find_by(id: params[:id])
      if epub.blank?
        render json: {error: 'epub not found'}, status: :unprocessable_entity
      else
        render json: EpubSerializer.new(epub).serializable_hash, status: :ok
      end
    end

    private

    def filter_epub
      @epubs = Epub.all
      params.each do |key, value|
        case key
        when 'category'
          @epubs = @epubs.joins(:contentable => :category).where(contentable: {categories: {id: value}})
        when 'sub_category'
          @epubs = @epubs.joins(:contentable => :sub_category).where(contentable: {sub_categories: {id: value}})
        when 'is_popular'
          @epubs = @epubs.joins(:contentable).where(contents: {is_popular: value})
        when 'is_trending'
          @epubs = @epubs.joins(:contentable).where(contents: {is_trending: value})
        end
      end
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id) }
      options
    end
  end
end
