module BxBlockContentmanagement
  class AudioPodcastsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index, :home_audio_podcasts, :show]
    def index
      filter_audio_podcast
      @audio_podcasts = AudioPodcast.all.page(params[:page]).per(params[:per_page])
      render json: AudioPodcastSerializer.new(@audio_podcasts, serialization_options).serializable_hash, status: :ok
    end

    def home_audio_podcasts
      audio_podcasts = AudioPodcast.joins(:contentable)
      data =  [
            {title: 'popular', list: AudioPodcastSerializer.new(audio_podcasts.where(contents: {is_popular: true}), serialization_options)},
            {title: 'trending', list: AudioPodcastSerializer.new(audio_podcasts.where(contents: {is_trending: true}), serialization_options)}
          ]
      render :json => {data: data}, status: :ok
    end

    def show
      audio_podcast = BxBlockContentmanagement::AudioPodcast.find_by(id: params[:id])
      if audio_podcast.blank?
        render json: {error: 'audio_podcast not found'}, status: :unprocessable_entity
      else
        render json: AudioPodcastSerializer.new(audio_podcast, serialization_options).serializable_hash, status: :ok
      end
    end

    private

    def filter_audio_podcast
      @audio_podcasts = AudioPodcast.all
      params.each do |key, value|
        case key
        when 'category'
          @audio_podcasts = @audio_podcasts.joins(:contentable => :category).where(contentable: {categories: {id: value}})
        when 'sub_category'
          @audio_podcasts = @audio_podcasts.joins(:contentable => :sub_category).where(contentable: {sub_categories: {id: value}})
        when 'is_popular'
          @audio_podcasts = @audio_podcasts.joins(:contentable).where(contents: {is_popular: value})
        when 'is_trending'
          @audio_podcasts = @audio_podcasts.joins(:contentable).where(contents: {is_trending: value})
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