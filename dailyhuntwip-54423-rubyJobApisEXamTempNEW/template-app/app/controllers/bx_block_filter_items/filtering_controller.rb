# frozen_string_literal: true

module BxBlockFilterItems
  class FilteringController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:content_page_filters]

    def index
      @catalogues = CatalogueFilter.new(
        ::BxBlockCatalogue::Catalogue, params[:q]
      ).call

      render json: ::BxBlockCatalogue::CatalogueSerializer
        .new(@catalogues, serialization_options)
        .serializable_hash
    end

    def content_page_filters
      result = {}
      # fetching all the publised contents
      @contents = BxBlockContentmanagement::Content.published.includes(:category, :sub_category, :content_type,
                                                                       :language)
      # applying filters to the published contents.
      @contents = filter_content

      # calling assign_variables to get the counts of filters.
      assign_variables
      # below will be the serialization of datas
      if @content_types
        result['content_types'] =
          serialize_data(@content_types, 'BxBlockContentmanagement::ContentType',
                          'BxBlockContentmanagement::ContentTypeSerializer')
      end
      if @categories
        result['categories'] =
          serialize_data(@categories, 'BxBlockCategories::Category',
                          'BxBlockCategories::CategorySerializer')
      end
      if @sub_categories
        result['sub_categories'] =
          serialize_data(@sub_categories, 'BxBlockCategories::SubCategory',
                          'BxBlockCategories::SubCategorySerializer')
      end
      if @languages
        result['languages'] =
          serialize_data(@languages, 'BxBlockLanguageoptions::Language',
                          'BxBlockLanguageoptions::LanguageSerializer')
      end
      if @content_providers
        result['content_providers'] =
          serialize_data(@content_providers, 'BxBlockAdmin::AdminUser',
                          'BxBlockContentmanagement::ContentProviderSerializer')
      end
      if @tags
        result['tags'] =
          serialize_data(@tags, 'ActsAsTaggableOn::Tag', 'BxBlockContentmanagement::TagSerializer')
      end
      if @publish_dates.present?
        result['publish_dates'] =
          { 'start_date': @publish_dates.min.strftime('%d/%m/%Y'),
            'end_date': @publish_dates.max.strftime('%d/%m/%Y') }
      end
      render json: { data: result.as_json, success: true, message: 'Success' }
    end

    private

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end

    def filter_content
      params.each do |key, value|
        case key
        when 'content_type'
          @contents = @contents.where(content_types: { id: value })
        when 'category'
          @contents = @contents.where(categories: { id: value })
        when 'sub_category'
          @contents = @contents.where(sub_categories: { id: value })
        when 'content_language'
          @contents = @contents.where(languages: { id: value })
        when 'content_provider'
          @contents = @contents.where(admin_user_id: value)
        when 'tag'
          @contents = @contents.tagged_with(value, any: true)
        when 'date'
          @contents = @contents.where('(publish_date < ?) and (publish_date > ?)', value['to'].to_datetime,
                                      value['from'].to_datetime)
        end
      end
      @contents
    end

    def assign_variables
      @content_types = @contents.pluck(:content_type_id) if params['current_page'] == 'content_type'
      @categories = @contents.pluck(:category_id) if params['current_page'] == 'category'
      @sub_categories = @contents.pluck(:sub_category_id) if params['current_page'] == 'sub_category'
      @languages = @contents.pluck(:language_id) if params['current_page'] == 'content_language'
      @content_providers = @contents.pluck(:admin_user_id) if params['current_page'] == 'content_provider'
      if params['current_page'] == 'tag'
        @tags = ActsAsTaggableOn::Tag.joins(:taggings).where(
          "taggings.taggable_id in (?) AND taggings.taggable_type = 'BxBlockContentmanagement::Content'", @contents.pluck(:id)
        ).pluck(:id)
      end
      @publish_dates = @contents.pluck(:publish_date)
    end

    def serialize_data(data, model, serializer)
      filter_counts = build_count_hash(data)
      obj = model.constantize.find(filter_counts.keys)
      serialization_options = { params: { count: filter_counts } }
      serialization_options[:params][:sub_categories] = true if model == 'BxBlockCategories::Category'
      serialization_options[:params][:categories] = true if model == 'BxBlockCategories::SubCategory'
      serializer.constantize.new(obj, serialization_options)
    end

    def build_count_hash(data)
      data.each_with_object(Hash.new(0)) { |i, d| d[i] += 1; }
    end
  end
end
