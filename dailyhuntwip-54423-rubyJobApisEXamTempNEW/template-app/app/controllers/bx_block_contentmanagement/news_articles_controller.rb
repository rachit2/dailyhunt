module BxBlockContentmanagement
  class NewsArticlesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]
    def index
      contents = Content.published.includes(:category, :sub_category, :content_type, :language)
      news_articles = contents.where(content_types: {identifier: 'news_article'})
      data =  [
            {title: 'popular', list: ContentSerializer.new(news_articles.where(is_popular: true), serialization_options)},
            {title: 'trending', list: ContentSerializer.new(news_articles.where(is_trending: true), serialization_options)},
            {title: 'recommended_articles', list: []}
          ]
      render :json => {data: data}, status: :ok
    end

    private 

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id) }
      options
    end
  end
end