module BxBlockExperts
  class CareerExpertsController < ApplicationController

    before_action :find_experts, only: %i[index]
    before_action :find_expert, only: %i[show book_or_follow get_video get_text follow_content]
    before_action :validate_request, only: :book_or_follow
    skip_before_action :validate_json_web_token, only: [:get_videos, :get_blogs, :get_articles]

    def index
      @experts = @experts.page(params[:page]).per(params[:per_page])
      render json: BxBlockExperts::ExpertSerializer.new(@experts,serialization_options).serializable_hash.merge(is_next: @experts.next_page.present?, total_pages: @experts.total_pages), status: :ok
    end

    def get_video
      @video = @expert.content_videos&.find(params[:content_video_id])
      @video.update(view_count: @video.view_count + 1) if @video.present?
      render json:BxBlockContentmanagement::ContentVideoSerializer.new(@video, params:{current_user_id:current_user&.id}).serializable_hash, status: :ok
    end

    def get_text
      @video = @expert.content_texts&.find(params[:content_text_id])
      @video.update(view_count: @video.view_count + 1) if @video.present?
      render json:BxBlockContentmanagement::ContentTextSerializer.new(@video,params:{current_user_id:current_user&.id}).serializable_hash, status: :ok
    end

    def get_videos
      videos = BxBlockContentmanagement::ContentVideo.joins(:career_expert)
      render json: BxBlockContentmanagement::ContentVideoSerializer.new(videos), status: :ok
    end

    def get_blogs
      blogs = BxBlockContentmanagement::ContentText.joins(:career_expert, contentable: :content_type).where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["blog"]})
      render json: BxBlockContentmanagement::ContentTextSerializer.new(blogs), status: :ok
    end

    def get_articles
      articles = BxBlockContentmanagement::ContentText.joins(:career_expert, contentable: :content_type).where(content_types:{identifier:BxBlockContentmanagement::ContentType.identifiers["news_article"]})
      render json: BxBlockContentmanagement::ContentTextSerializer.new(articles), status: :ok
    end

    def show
      return if @expert.nil?
      render json: BxBlockExperts::ExpertSerializer.new(@expert, serialization_options)
                                                 .serializable_hash,
             status: :ok
    end

    def book_or_follow
      return if @expert.nil?
      current_user.account_experts.create!(career_expert_id:@expert.id, mode:@mode)
      render json: {
        status: { code: 200, message: "#{@mode}ed Succesfully" },
        data: BxBlockExperts::ExpertSerializer.new(@expert, serialization_options).serializable_hash[:data]
      }
    end

    def follow_content
      @video = @expert.content_videos&.find_by(id:params[:content_id])
      @text = @expert.content_texts&.find_by(id:params[:content_id]) unless @video
      if @video
        follower = current_user.followers.create!(content_video_id:@video.id) unless current_user.followers&.find_by(content_video_id:@video.id)
      elsif @text
        follower = current_user.followers.create!(content_text_id:@text.id) unless current_user.followers&.find_by(content_text_id:@text.id)
      else
        render json: {
          message: "Content with id #{params[:content_id]} doesn't exists"
        }, status: :not_found
      end
      return render json: {
        message: "Already Followed"
      }, status: :not_found  unless follower
      render json:BxBlockContentmanagement::FollowSerializer.new(follower), status: :ok
    end

    def show_follow_contents
      @followers = current_user.followers
      filter_followers
      render json:BxBlockContentmanagement::FollowSerializer.new(@followers,serialization_options), status: :ok
    end

    def show_follow_content
      text = current_user.followers&.find_by(content_text_id:params[:content_id])
      video = current_user.followers&.find_by(content_video_id:params[:content_id]) unless text
      content = text ? text : video
      update_view_count = text ? content.content_text : content.content_video
      update_view_count.update(view_count: update_view_count.view_count + 1) if update_view_count.present?
      render json:BxBlockContentmanagement::FollowSerializer.new(content,serialization_options), status: :ok
    end

    def unfollow_content
      text = current_user.followers&.find_by(content_text_id:params[:content_id])&.destroy
      video = current_user.followers&.find_by(content_video_id:params[:content_id])&.destroy unless text
      render json:{message: "Unfollow Success"}, status: :ok
    end

    private

    def filter_followers
      @followers = @followers&.where&.not(content_text_id:nil) if params[:content_type] == "article" || params[:content_type] =="blog"
      @followers = @followers&.where&.not(content_video_id:nil) if params[:content_type] == "video"
      if params[:content_type] =="article"
        @followers = @followers.article_follows
      elsif params[:content_type] == "blog"
        @followers = @followers.blog_follows
      end
      @followers
    end

    def validate_request
      @mode = params[:mode]
      return (render json:{errors:"Please enter valid mode"}) unless params[:mode]
      return (render json: {errors: "Already #{params[:mode]}"}, status: :unprocessable_entity) if @expert.account_experts.where(account_id:current_user.id, mode:@mode)&.present?
    end

    def find_expert
      @expert = BxBlockExperts::CareerExpert.find_by(id: params[:id])
      if @expert.nil?
        render json: {
          message: "Expert with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def find_experts
      @experts = BxBlockExperts::CareerExpert.order(:name)
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port, current_user_id: (current_user&.id), is_featured:params[:is_featured], is_popular: params[:is_popular] } }
    end

  end
end