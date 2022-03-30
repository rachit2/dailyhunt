module BxBlockCommunityforum
  class LikesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      like = BxBlockCommunityforum::Like.find(params[:id])
      render json: LikeSerializer.new(like).serializable_hash, status: :ok
    end

    def index
      likes = BxBlockCommunityforum::Like.all
      likes = likes.page(params[:page]).per(params[:per_page]) if (params[:page].present? || params[:per_page].present?)
      render json: LikeSerializer.new(likes).serializable_hash, status: :ok
    end

    def create
      if params[:like].present? and params[:like][:likeable_type].present?
        params[:like][:likeable_type] = BxBlockCommunityforum::Like::TYPE_MAPPINGS[params[:like][:likeable_type]]
        like = current_user.likes.where(likeable_id: params[:like][:likeable_id], likeable_type: params[:like][:likeable_type])&.last
        if like.present?
            if like.update(like_params)
                render json: BxBlockCommunityforum::LikeSerializer.new(like, meta: {success: true, message: 'updated'}).serializable_hash, status: :created
            else
                render json: {meta: [{success: false, message: format_activerecord_errors(like.errors)}]}, status: :unprocessable_entity
            end
        else
            like = current_user.likes.new(like_params)
            if like.save
              render json: BxBlockCommunityforum::LikeSerializer.new(like, meta: {success: true, message: 'created'}).serializable_hash, status: :created
            else
              render json: {meta: [{success: false, message: format_activerecord_errors(like.errors)}]}, status: :unprocessable_entity
            end
        end
      else
        render json: {meta: [{success: false, message: 'Please insert type'}]}, status: :unprocessable_entity
      end
    end

    def delete_like
      params[:like][:likeable_type] = BxBlockCommunityforum::Like::TYPE_MAPPINGS[params[:like][:likeable_type]]
      like = current_user.likes.where(likeable_id: params[:like][:likeable_id], likeable_type: params[:like][:likeable_type])&.last
      if like.present? 
        like.destroy
        render json: {meta: [{success: true, message: 'Successfully destroyed like'}]}, status: :ok
      else
        render json: {meta: [{success: false, message: 'Invalid Data'}]}, status: :unprocessable_entity
      end
    end

    private

    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id}
      options
    end

    def like_params
      params.require(:like).permit(:likeable_id, :likeable_type, :is_like)
    end
  end
end
