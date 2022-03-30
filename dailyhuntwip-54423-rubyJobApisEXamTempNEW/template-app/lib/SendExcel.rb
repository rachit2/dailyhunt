require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class SendExcel < RailsAdmin::Config::Actions::Base

        register_instance_option :root? do
          true
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
            file_obj = params[:upload]
            response = BxBlockLanguageoptions::ImportDataService.store_data(file_obj.path)

            if response[:success]
              flash[:success] = "Sucessfully imported data for Application Messages."
              redirect_to index_path('bx_block_languageoptions~application_message')
            else
              flash[:error] = response[:error]
              render :import_excel
            end
          end
        end
      end
    end
  end
end
