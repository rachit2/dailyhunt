module BxBlockContentmanagement
  class FollowsController < ApplicationController
    before_action :validate_json_web_token, only: [:create, :destroy, :index, :followers_content, :unfollow]
    
    def create
      content_provider = BxBlockAdmin::AdminUser.find(params[:content_provider_id])
      if content_provider.partner?
        follow = current_user.followers.new(content_provider_id: params[:content_provider_id])

        if follow.save
          render json: FollowSerializer.new(follow).serializable_hash,
               status: :created
        else
          render json: ErrorSerializer.new(follow).serializable_hash,
               status: :unprocessable_entity
        end
      else
        render json: {error: "you can only follow partner."}
      end
    end

    def index
      render json: BxBlockContentmanagement::ContentProviderSerializer.new(current_user.content_provider_followings, serialization_options).serializable_hash, status: :ok
    end

    def followers_content
      contents = BxBlockContentmanagement::Content.where(admin_user: current_user.content_provider_followings)
      render json: ContentSerializer.new(contents, serialization_options).serializable_hash,
             status: :ok
    end

    def unfollow
      follows = current_user.followers.where(content_provider_id: params[:content_provider_id])
      if follows.destroy_all
        render json: { success: true }, status: :ok
      else
        render json: ErrorSerializer.new(follows).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private
    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id}
      options
    end
  end
end
