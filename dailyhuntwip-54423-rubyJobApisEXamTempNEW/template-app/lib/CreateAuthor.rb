require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class CreateAuthor < RailsAdmin::Config::Actions::Base

        register_instance_option :collection do
          true
          only ['BxBlockContentmanagement::Content']
        end

        register_instance_option :visible do
          false
        end

        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :show_in_sidebar do
          false
        end

        register_instance_option :controller do
          proc do
            author_params = params.require(:bx_block_contentmanagement_content).require(:author).permit(:name, :bio, image_attributes: [:image])
            @author = BxBlockContentmanagement::Author.new(author_params)
            if @author.save
              render json: {author: @author} 
            else
              render json: {errors: @author.errors.full_messages.to_sentence}, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
