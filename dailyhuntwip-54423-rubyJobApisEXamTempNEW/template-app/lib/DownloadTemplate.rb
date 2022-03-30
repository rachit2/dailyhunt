require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class DownloadTemplate < RailsAdmin::Config::Actions::Base
        register_instance_option :root? do
          true
        end

        register_instance_option :visible do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :show_in_sidebar do
          false
        end

        register_instance_option :controller do
          proc do
             send_file(
            "#{Rails.root}/public/ContentData.xlsx",
            filename: "ContentData.xlsx",
            type: "application/xlsx"
          )
          end
        end
      end
    end
  end
end
