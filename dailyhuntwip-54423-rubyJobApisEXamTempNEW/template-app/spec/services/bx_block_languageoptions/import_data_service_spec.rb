require 'rails_helper'
require 'roo'
require 'rubyXL/convenience_methods'
require 'json'

RSpec.describe BxBlockLanguageoptions::CreateAndUpdateTranslations, type: :services do
  
  context 'should import data' do
    let(:observed_response_json) do
        {
          success: false, 
          error: "Please add translations sheet"
        }
      end
    it 'should raise error when translations sheet not present' do
      workbook = RubyXL::Workbook.new
      workbook[0].sheet_name = 'translations'
      file = workbook.write("file.xlsx")                              
      response = BxBlockLanguageoptions::ImportDataService.store_data(file)
      File.delete('./file.xlsx')
      expect(response).to eq(observed_response_json)
    end

    it 'should create or update all appication messages which are present in sheet'do 
      BxBlockLanguageoptions::BuildLanguages.call
      BxBlockLanguageoptions::CreateAndUpdateTranslations.call
      workbook = RubyXL::Workbook.new
      workbook[0].sheet_name = 'translations_sheet'
      workbook[0].add_cell(0, 0, 'sn')
      workbook[0].add_cell(0, 1, 'key')
      i = 2
      language_codes = [I18n.default_locale.to_s]
      language_codes.push(*BxBlockLanguageoptions::Language.pluck(:language_code).compact) if BxBlockLanguageoptions::Language.table_exists? rescue false
      I18n.available_locales = language_codes.uniq
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
      file = workbook.write("file.xlsx")                              
      response = BxBlockLanguageoptions::ImportDataService.store_data(file)
      expect(response).to eq(success: true)
      File.delete('./file.xlsx')
    end
  end

end