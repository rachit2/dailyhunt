require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class ImportExcel < RailsAdmin::Config::Actions::Base
        register_instance_option :collection do
          true
          only ['BxBlockLanguageoptions::ApplicationMessage']
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :link_icon do
          # font awesome icons. but an older version
          'fa fa-upload'
        end
        register_instance_option :controller do
          proc do
          end
        end
      end
    end
  end
end
