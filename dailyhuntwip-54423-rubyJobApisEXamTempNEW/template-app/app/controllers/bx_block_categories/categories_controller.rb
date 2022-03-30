module BxBlockCategories
  class CategoriesController < ApplicationController
    before_action :load_category, only: [:show]
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      return if @category.nil?

      render json: CategorySerializer.new(@category, serialization_options)
                       .serializable_hash,
             status: :ok
    end

    def index
      serializer = if params[:sub_category_id].present?
                     categories = SubCategory.find(params[:sub_category_id])
                                      .categories.order(:rank)
                     CategorySerializer.new(categories)
                   else
                     CategorySerializer.new(Category.all.order(:rank), serialization_options)
                   end

      render json: serializer, status: :ok
    end

    def update
      if current_user.update(category_ids: params[:categories_ids])
        serializer = CategorySerializer.new(current_user.categories)
        serialized = serializer.serializable_hash
        render :json => serialized
      else
        render :json => {:errors => current_user.errors,
          :status => :unprocessable_entity}
      end
    end

    private

    def load_category
      @category = Category.find_by(id: params[:id])

      if @category.nil?
        render json: {
            message: "Category with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      options = {}
      options[:params] = { sub_categories: true }
      options
    end

    def remove_not_used_subcategories
      sql = "delete from sub_categories sc where sc.id in (
               select sc.id from sub_categories sc
               left join categories_sub_categories csc on
                 sc.id = csc.sub_category_id
               where csc.sub_category_id is null
             )"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
