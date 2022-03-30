module BxBlockContentmanagement
  class ContentsController < ApplicationController
    before_action :assign_contents, only: [:index, :show, :recommended_videos, :recommend_audio_podcasts]
    skip_before_action :validate_json_web_token, only: [:get_content_detail, :index, :show, :bannerable, :reindex_contents, :run_seeds, :get_content_provider]
    before_action :assign_json_web_token, only: [:index, :recommended_videos, :recommend_audio_podcasts]
    before_action :authorize_request, only: [:reindex_contents, :run_seeds]
    before_action :check_current_partner, :set_category, :set_sub_category, :set_content_type, :set_language, only: [:contents, :update_contents]
    before_action :index_content, only: [:index]
    before_action :detail_content, only: [:show]
    before_action :set_content, only: [:update_contents]
    before_action :check_bannerable, only: [:bannerable]

    def get_content_detail
      @content_type_id = params[:id]
      content_type_obj = ContentType.find_by(id: params["id"])
      @content_type = content_type_obj&.type
      @content_name = content_type_obj&.name

      @contentable = Content.find_by(id: params[:content_id])&.contentable if params[:content_id].present?
      if @content_type.present?
        render 'rails_admin/application/form_template'
      end
    end

    def recommended_videos
      contents = @contents.where(category: current_user.categories, content_types: {identifier: ['video_short', 'video_full']}).page(params[:page]).per(params[:per_page])
      render json: ContentSerializer.new(contents, serialization_options).serializable_hash, status: :ok
    end

    def recommend_audio_podcasts
      contents = @contents.where(category: current_user.categories, content_types: {identifier: ['audio_podcast']}).page(params[:page]).per(params[:per_page])
      render json: ContentSerializer.new(contents, serialization_options).serializable_hash, status: :ok
    end

    def bannerable
      render json: {content: BannerableSerializer.new(@bannerable).serializable_hash}, status: :ok
    end

    def contents
      tags = params[:tag_list]
      content = BxBlockBulkUpload::CreateContentService.create_content(@content_type, content_params, @sub_category, @language, @category, tags, @admin_user.id)
      if content.present? && content[:errors].present?
        render json: {errors: content[:errors], status: 404}
      else
        render json: {content: ContentSerializer.new(content).serializable_hash, success: true, message: "Content created successfully!"}
      end
    end

    def update_contents
      tags = params[:tag_list]
      content = BxBlockBulkUpload::CreateContentService.create_content(@content_type, update_params, @sub_category, @language, @category, tags, @admin_user.id)
      if content.present? && content[:errors].present?
        render json: {errors: content[:errors], status: 404}
      else
        render json: {content: ContentSerializer.new(content).serializable_hash, success: true, message: "Content updated successfully!"}
      end
    end

    def index
      filter_content
      if params[:search].present?
        @contents = Content.search(params[:search], fields: Content::SEARCHABLE_FIELDS, misspellings: false, match: :text_middle, page: params[:page], per_page: params[:per_page], where: { id: @contents.ids })
      else
        @contents = @contents.page(params[:page]).per(params[:per_page])
      end
      content_serializer = ContentSerializer.new(@contents, serialization_options)
      if !params[:with_cta]
        render json: content_serializer.serializable_hash.merge(is_next: @contents.next_page.present?, total_pages: @contents.total_pages), status: :ok
      else
        per_page = params[:per_page] || 20
        content_count_per_cta = params[:content_count_per_cta] || 2
        ctas = BxBlockCategories::Cta.includes(:category).page(params[:page]).per(per_page.to_i/content_count_per_cta.to_i)
        cta_serializer = BxBlockCategories::CtaSerializer.new(ctas)
        contents_with_cta = get_contents_with_cta(content_serializer.serializable_hash, cta_serializer.serializable_hash, content_count_per_cta)
        render json: contents_with_cta.merge(is_next: @contents.next_page.present?, total_pages: @contents.total_pages), status: :ok
      end
    end

    def show
      @content = @contents.find(params[:id])
      @content.update(view_count: @content.view_count + 1)
      render json: ContentSerializer.new(@content, serialization_options).serializable_hash, status: :ok
    end

    def reindex_contents
      BxBlockContentmanagement::Content.reindex
      render json: { message: "Content reindexed Successfully!" }
    end

    def run_seeds
      load Rails.root + "db/seeds.rb"
      render json: { message: "Successfully! run seeds" }
    end

    def get_content_provider
      if params[:category_id].present? and params[:sub_category_id].present? and params[:content_type_id].present?
        content_provider = BxBlockAdmin::AdminUser.filter_content_provider(params[:category_id], params[:sub_category_id], params[:content_type_id]).select(:id, :email)
        render json: { content_provider: content_provider }
      else
        render json: { content_provider: [] }
      end
    end

    private

    def assign_contents
      @contents = Content.published.includes(:category, :sub_category, :content_type, :language)
    end

    def set_content
      @content = BxBlockContentmanagement::Content.find(params[:id])
    end

    def set_category
      @category = BxBlockCategories::Category.find_by(id: params[:category_id])
      unless @category.present?
        return render json: {error: "can't find category with this id '#{params[:category_id]}'"}
      end
    end

    def content_params
      params.permit(:category_id, :sub_category_id, :language_id, :author_id, :headline, :description, :feature_article, :is_featured, :is_popular, :is_trending, :feature_video, :searchable_text, :content_type_id, :archived, :status, :publish_date, :tag_list, :heading, :content, :hyperlink, :affiliation, :url, :separate_section, images_attributes: [:image], videos_attributes: [:video], image_attributes: [:image], audio_attributes: [:audio], pdfs_attributes: [:pdf], video_attributes: [:video])
    end

    def update_params
      content_params.merge(id: params[:id])
    end

    def set_sub_category
      @sub_category = BxBlockCategories::SubCategory.find_by(id: params[:sub_category_id])
      unless @sub_category.present?
        return render json: {error: "can't find sub category with this id '#{params[:sub_category_id]}'"}
      end
    end

    def set_content_type
      @content_type = BxBlockContentmanagement::ContentType.find_by(id: params[:content_type_id])
      unless @content_type.present?
        return render json: {error: "can't find content type with this id '#{params[:content_type_id]}'"}
      end
    end

    def set_language
      @language = BxBlockLanguageoptions::Language.find_by(id: params[:language_id])
      unless @language.present?
        return render json: {error: "can't find language with this id '#{params[:language_id]}'"}
      end
    end

    def check_current_partner
      admin_user_id = @token.id
      @admin_user = BxBlockAdmin::AdminUser.partner_user.find(admin_user_id)
    end

    def filter_content
      params.each do |key, value|
        case key
        when 'content_type'
          @contents = @contents.where(content_types: {id: value})
        when 'category'
          @contents = @contents.where(categories: {id: value})
        when 'date'
          @contents = @contents.where("(publish_date < ?) and (publish_date > ?)", value["to"].to_datetime, value["from"].to_datetime)
        when 'feature_article'
          @contents = @contents.where(content_types: {type: "Text"}).where(is_featured: value)
        when 'feature_video'
          @contents = @contents.where(content_types: {type: "Videos"}).where(is_featured: value)
        when 'feature_blog'
          @contents = @contents.where(content_types: {identifier: "blog"}).where(is_featured: value)
        when 'content_language'
          @contents = @contents.where(languages: {id: value})
        when 'sub_category'
          @contents = @contents.where(sub_categories: {id: value})
        when 'tag'
          @contents = @contents.tagged_with(value, any: true)
        when 'content_provider'
          @contents = @contents.where(admin_user_id: value)
        when 'content_type_name'
          @contents = @contents.where(content_types: {identifier: value})
        when 'is_popular'
          @contents = @contents.where(is_popular: value)
        when 'is_trending'
          @contents = @contents.where(is_trending: value)
        when 'is_featured'
          @contents = @contents.where(is_featured: value)
        when 'is_recommended'
          @contents = @contents.where(category: current_user&.categories)
        end
      end
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id) }
      options
    end

    def authorize_request
      return render json: {data: [
        {account: "Please use correct api_access_key."},
      ]}, status: 401 unless Rails.application.secrets.api_access_key == params[:api_access_key]
    end

    def get_contents_with_cta(content_serializer, cta_serializer, content_count_per_cta)
      ctas = cta_serializer[:data].to_a
      if ctas.present?
        contents = content_serializer[:data].in_groups_of(content_count_per_cta, false)
        data = contents.zip(ctas).flatten
        {data: data.reject(&:blank?)}
      else
        content_serializer
      end
    end

    def check_bannerable
      bannerable_params = params.permit(:bannerable)
      @bannerable = (['BxBlockContentmanagement::Course', 'BxBlockContentmanagement::Quiz','BxBlockContentmanagement::Exam', "BxBlockExperts::CareerExpert",'BxBlockJobs::Job','BxBlockContentmanagement::Assessment', 'BxBlockContentmanagement::ContentText', 'BxBlockContentmanagement::ContentVideo', 'BxBlockContentmanagement::LiveStream', 'BxBlockContentmanagement::AudioPodcast', 'BxBlockContentmanagement::Test', 'BxBlockContentmanagement::Epub'].include? bannerable_params[:bannerable]) ? bannerable_params[:bannerable].constantize.all : []
    end

    def index_content
      content = BxBlockBulkUpload::XmlIndexContentService.create_content
    end

    def detail_content
      content = BxBlockBulkUpload::XmlDetailContentService.create_content(params[:id])
    end
  end
end
