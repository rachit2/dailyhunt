require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class BulkUpload < RailsAdmin::Config::Actions::Base

        register_instance_option :root? do
          true
        end

        register_instance_option :visible do
          authorized?
        end

        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :show_in_sidebar do
          false
        end

        register_instance_option :controller do
          proc do
            file_obj = params[:upload]
            response = BxBlockBulkUpload::BulkUploadService.store_data(file_obj.path, _current_user.id)
            if response[:success]
              flash[:success] = "Sucessfully imported data "
              redirect_to index_path('import_data')
            else
              @errors = response[:errors]
              render :import_data
            end
          end
        end
      end
    end
  end
end
