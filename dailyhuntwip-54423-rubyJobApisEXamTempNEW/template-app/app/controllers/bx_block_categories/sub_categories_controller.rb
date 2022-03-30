module BxBlockCategories
  class SubCategoriesController < ApplicationController
    before_action :load_sub_category, only: [:show]
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      return if @sub_category.nil?

      render json: SubCategorySerializer.new(@sub_category).serializable_hash,
             status: :ok
    end

    def index
      serializer = if params[:category_id].present?
                     sub_categories = Category.find(params[:category_id])
                                          .sub_categories
                     SubCategorySerializer.new(sub_categories)
                   else
                     SubCategorySerializer.new(
                       SubCategory.all,
                       serialization_options
                     )
                   end

      render json: serializer, status: :ok
    end

    def update
      if current_user.update(sub_category_ids: params[:sub_categories_ids])
        serializer = SubCategorySerializer.new(current_user.sub_categories)
        serialized = serializer.serializable_hash
        render :json => serialized
      else
        render :json => {:errors => current_user.errors,
          :status => :unprocessable_entity}
      end
    end

    private

    def load_sub_category
      @sub_category = SubCategory.find_by(id: params[:id])

      if @sub_category.nil?
        render json: {
            message: "SubCategory with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      options = {}
      options[:params] = { categories: true }
      options
    end
  end
end
