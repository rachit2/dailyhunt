require 'rails_helper'
require 'roo'
require 'rubyXL/convenience_methods'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }

  describe 'send excel engine' do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    before do
      sign_in user
    end

    context 'save translations' do
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
        xlsx = Roo::Spreadsheet.open(@file)
      end

      it 'should have status 302 and show flash message' do
        post 'send_excel', params: { upload: Rack::Test::UploadedFile.new(@file) }
        File.delete('./file.xlsx')
        expect(flash[:success]).to eq "Sucessfully imported data for Application Messages."
        expect(response.status).to eq (302)
        expect(response).to redirect_to('/admin/bx_block_languageoptions~application_message')
      end

      it 'should raise error when translations sheet not have sn' do
        @workbook[0].add_cell(0, 0, '')  
        file = @workbook.write("file.xlsx")       
        post 'send_excel', params: { upload: Rack::Test::UploadedFile.new(@file) }           
        File.delete('./file.xlsx')
        expect(flash[:error]).to eq "missing headers: sn in translations sheet"
      end

      it 'should raise error when translations sheet not have key' do
        @workbook[0].add_cell(0, 1, '')  
        file = @workbook.write("file.xlsx")      
        post 'send_excel', params: { upload: Rack::Test::UploadedFile.new(@file) }           
        File.delete('./file.xlsx')
        expect(flash[:error]).to eq "missing headers: key in translations sheet"
      end

      it 'should raise error when translations sheet not have key' do
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
        post 'send_excel', params: { upload: Rack::Test::UploadedFile.new(@file) }           
        File.delete('./file.xlsx')
        expect(flash[:error]).to eq "No data present in translations sheet"
      end

    end
  end
  
end