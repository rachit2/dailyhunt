require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class BuildContent < RailsAdmin::Config::Actions::Base
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
          [:get]
        end

        register_instance_option :show_in_sidebar do
          true
        end

        register_instance_option :link_icon do
          # font awesome icons. but an older version
          'icon-plus'
        end

        register_instance_option :controller do
          proc do
            if params[:id].present?
              @content = BxBlockContentmanagement::Content.find_by(id: params[:id])
            else
              @content = BxBlockContentmanagement::Content.new()
            end
            @content_name = @content&.content_type&.name
            @content_type = @content&.content_type&.type
            @contentable = @content&.contentable
            render @action.template_name
          end
        end
      end
    end
  end
end
