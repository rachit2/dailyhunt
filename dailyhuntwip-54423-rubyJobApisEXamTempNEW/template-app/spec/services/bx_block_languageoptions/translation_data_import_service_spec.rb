require 'rails_helper'
require 'roo'
require 'rubyXL/convenience_methods'
require 'json'

RSpec.describe BxBlockLanguageoptions::TranslationDataImportService, type: :services do
  
  context 'should import data' do
    let(:missing_headers_json) do
        {
          success: false, 
          error: "missing headers: sn in translations sheet"
        }
      end
    let(:missing_key_json) do
        {
          success: false, 
          error: "missing headers: key in translations sheet"
        }
      end
    let(:no_data_json) do
        {
          success: false, 
          error: "No data present in translations sheet"
        }
      end
    before(:each) do
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
      @file = workbook.write("file.xlsx")
      @workbook = workbook
    end
    it 'should raise error when translations sheet not have sn' do
      @workbook[0].add_cell(0, 1, '')  
      file = @workbook.write("file.xlsx")  
      xlsx = Roo::Spreadsheet.open(file)                  
      translation_data_import = BxBlockLanguageoptions::TranslationDataImportService.new                     
      response = translation_data_import.store_data(xlsx)
      File.delete('./file.xlsx')
      expect(response).to eq(missing_key_json)
    end

    it 'should raise error when translations sheet not have key' do
      @workbook[0].add_cell(0, 0, '')  
      file = @workbook.write("file.xlsx")  
      xlsx = Roo::Spreadsheet.open(file)                  
      translation_data_import = BxBlockLanguageoptions::TranslationDataImportService.new                     
      response = translation_data_import.store_data(xlsx)
      File.delete('./file.xlsx')
      expect(response).to eq(missing_headers_json)
    end

    it "should raise error when translations sheet doesn't have any data" do
      i = 2
      language_codes = [I18n.default_locale.to_s]
      language_codes.push(*BxBlockLanguageoptions::Language.pluck(:language_code).compact) if BxBlockLanguageoptions::Language.table_exists? rescue false
      i = 1
      BxBlockLanguageoptions::ApplicationMessage.all.each do |application_message|
        j = 0
        @workbook[0].add_cell(i, j, "")
        j +=1
        @workbook[0].add_cell(i, j,"")
        I18n.available_locales.each do |locale|
          j +=1
          translation = application_message.translations.find_by(locale: locale.to_s)
          message = translation.present? ? translation.message : nil
          @workbook[0].add_cell(i, j,"")
        end
        i +=1
      end
      file = @workbook.write("file.xlsx")  
      xlsx = Roo::Spreadsheet.open(file)
      translation_data_import = BxBlockLanguageoptions::TranslationDataImportService.new                     
      response = translation_data_import.store_data(xlsx)
      File.delete('./file.xlsx')
      expect(response).to eq(no_data_json)
    end

    it 'should get success response'do 
      xlsx = Roo::Spreadsheet.open(@file)      
      translation_data_import = BxBlockLanguageoptions::TranslationDataImportService.new                     
      response = translation_data_import.store_data(xlsx)
      expect(response).to eq(success: true)
      File.delete('./file.xlsx')
    end
  end

end