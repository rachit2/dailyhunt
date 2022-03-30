require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class CreateContent < RailsAdmin::Config::Actions::Base
        register_instance_option :collection do
          true
          only ['BxBlockContentmanagement::Content']
        end

        # register_instance_option :root? do
        #   true
        # end

        register_instance_option :visible do
          authorized?
        end

        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :show_in_sidebar do
          true
        end

        register_instance_option :link_icon do
          # font awesome icons. but an older version
          'icon-ok-sign content'
        end

        register_instance_option :controller do
          proc do
            content_params = params.require(:bx_block_contentmanagement_content).permit(:category_id, :sub_category_id, :language_id, :feature_article, :feature_video, :is_featured, :is_trending, :is_popular, :searchable_text, :content_type_id, :admin_user_id, :archived, :author_id, :status, :review_status, :feedback, :current_user_id, :publish_date, tag_list: [], contentable_attributes: {})
            content_params[:status] = params[:bx_block_contentmanagement_content][:status].to_i if params[:bx_block_contentmanagement_content][:status].present?  
            content_params[:review_status] = params[:bx_block_contentmanagement_content][:review_status].to_i if params[:bx_block_contentmanagement_content][:review_status].present?
            content_params[:admin_user_id] = params[:bx_block_contentmanagement_content][:current_user_id] if params[:bx_block_contentmanagement_content][:admin_user_id].blank? and params[:content_id].blank?

            if params[:content_id].present?
              @content = BxBlockContentmanagement::Content.find_by(id: params[:content_id])
              content_params[:admin_user_id] = @content.admin_user_id if params[:bx_block_contentmanagement_content][:admin_user_id].blank?
              @content.assign_attributes(content_params)
            else
              @content = BxBlockContentmanagement::Content.new(content_params)
            end
            @content_type = @content.content_type&.type
            @contentable = @content.contentable

            if @content.save
              if @content.admin_user.present? and @content.admin_user.operations_l1? and @content.submit_for_review?
                flash[:success] = "Content Saved Successfully! and Content will review by authorized user"
                redirect_to index_path('bx_block_contentmanagement~content')
              else
                flash[:success] = "Content Saved Successfully!"
                redirect_to show_path('bx_block_contentmanagement~content', @content), format: :html
              end
            else
              flash[:error] = @content.errors.full_messages.to_sentence
              render :build_content
            end
          end
        end
      end
    end
  end
end
