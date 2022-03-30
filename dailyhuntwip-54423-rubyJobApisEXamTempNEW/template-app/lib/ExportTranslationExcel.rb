require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'roo' 
require 'rubyXL/convenience_methods'

module RailsAdmin
  module Config
    module Actions
      class ExportTranslationExcel < RailsAdmin::Config::Actions::Base
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
            workbook = RubyXL::Workbook.new
            workbook[0].sheet_name = 'translations_sheet'
            workbook[0].add_cell(0, 0, 'sn')
            workbook[0].add_cell(0, 1, 'key')
            i = 2
            I18n.available_locales.each do |locale|
              workbook[0].add_cell(0, i,locale.to_s)
              i+=1
            end
            i = 1
            BxBlockLanguageoptions::ApplicationMessage.all.each do |application_message|
              j = 0
              workbook[0].add_cell(i, j, i)
              j +=1
              workbook[0].add_cell(i, j,application_message.name)
              I18n.available_locales.each do |locale|
                j +=1
                translation = application_message.translations.find_by(locale: locale.to_s)
                message = translation.present? ? translation.message : nil
                workbook[0].add_cell(i, j,message)
              end
              i +=1
            end
            send_data workbook.stream.string, filename: "translations.xlsx",
                                    disposition: 'attachment'
          end
        end
      end
    end
  end
end
