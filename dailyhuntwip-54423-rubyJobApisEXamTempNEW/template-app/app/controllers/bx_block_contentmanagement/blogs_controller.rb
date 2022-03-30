module BxBlockContentmanagement
  class BlogsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]
    def index
      contents = Content.published.includes(:category, :sub_category, :content_type, :language)
      blogs = contents.where(content_types: {identifier: 'blog'})
      data =  [
            {title: 'popular', list: ContentSerializer.new(blogs.where(is_popular: true), serialization_options)},
            {title: 'trending', list: ContentSerializer.new(blogs.where(is_trending: true), serialization_options)},
            {title: 'recommended_blogs', list: []}
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