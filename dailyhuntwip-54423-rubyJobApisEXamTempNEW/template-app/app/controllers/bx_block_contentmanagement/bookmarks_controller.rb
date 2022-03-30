module BxBlockContentmanagement
  class BookmarksController < ApplicationController
    before_action :validate_json_web_token, only: [:create, :destroy, :index, :unfollow]
    before_action :build_bookmark, only: [:create]
    before_action :get_bookmark, only: [:unfollow]
    before_action :get_bookmarks, only: [:index]

    def create
      if @bookmark.save
        render json: BookmarkSerializer.new(@bookmark).serializable_hash,
             status: :created
      else
        render json: ErrorSerializer.new(@bookmark).serializable_hash,
             status: :unprocessable_entity
      end
    end

    def index
      render json: @serializer.new(@bookmarkables, serialization_options).serializable_hash,
             status: :ok
    end

    def unfollow
      if @bookmarks.destroy_all
        render json: { success: true }, status: :ok
      else
        render json: ErrorSerializer.new(@bookmarks).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private
    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id}
      options
    end


    def get_bookmarks
      case params[:bookmarkable]
      when 'course'
        @bookmarkables = current_user.course_followings
        @serializer  = BxBlockContentmanagement::CourseSerializer
      when 'job'
        @bookmarkables = current_user.job_followings
        @serializer  = BxBlockJobs::JobSerializer
      when 'expert'
        @bookmarkables = current_user.expert_followings
        @serializer  = BxBlockExperts::ExpertSerializer
      when 'company'
        @bookmarkables = current_user.company_followings
        @serializer = BxBlockCompanies::CompanySerializer
      else
        @bookmarkables = current_user.content_followings
        @serializer  = BxBlockContentmanagement::ContentSerializer
      end
    end

    def build_bookmark
      if params[:content_id].present?
        @bookmark = current_user.bookmarks.new(bookmarkable_id: params[:content_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS['content'])
      elsif params[:job_id].present?
        @bookmark = current_user.bookmarks.new(bookmarkable_id: params[:job_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS['job'])
      else
        @bookmark = current_user.bookmarks.new(bookmarkable_id: params[:bookmarkable_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS[params[:bookmarkable_type]])
      end
    end

    def get_bookmark
      if params[:content_id].present?
        @bookmarks = current_user.bookmarks.where(bookmarkable_id: params[:content_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS['content'])
      elsif params[:job_id].present?
        @bookmarks = current_user.bookmarks.where(bookmarkable_id: params[:job_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS['job'])
      else
        @bookmarks = current_user.bookmarks.where(bookmarkable_id: params[:bookmarkable_id], bookmarkable_type: BxBlockContentmanagement::Bookmark::TYPE_MAPPINGS[params[:bookmarkable_type]])
      end
    end
  end
end
