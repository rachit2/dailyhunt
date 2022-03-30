module BxBlockCommunityforum
  class CommentsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      comment = BxBlockCommunityforum::Comment.find(params[:id])
      render json: CommentSerializer.new(comment, serialization_options).serializable_hash, status: :ok
    end

    def index
      comments = BxBlockCommunityforum::Comment.all.page(params[:page]).per(params[:per_page])
      render json: CommentSerializer.new(comments).serializable_hash, status: :ok
    end

    def create
      if params[:comment].present? and params[:comment][:commentable_type].present?
        params[:comment][:commentable_type] = BxBlockCommunityforum::Comment::TYPE_MAPPINGS[params[:comment][:commentable_type]]
        comment = current_user.comments.new(comment_params)
        if comment.save
          render json: BxBlockCommunityforum::CommentSerializer.new(comment, meta: {success: true, message: 'created'}).serializable_hash, status: :created
        else
          render json: {meta: [{success: false, message: format_activerecord_errors(comment.errors)}]}, status: :unprocessable_entity
        end
      else
        render json: {meta: [{success: false, message: 'Please insert type'}]}, status: :unprocessable_entity
      end
    end


    private

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: current_user&.id, comments: true }
      options
    end

    def comment_params
      params.require(:comment).permit(:description, :commentable_id, :commentable_type)
    end
  end
end
