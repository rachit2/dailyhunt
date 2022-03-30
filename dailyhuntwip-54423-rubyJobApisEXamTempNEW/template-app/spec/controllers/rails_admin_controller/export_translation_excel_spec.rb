require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }

  describe 'export translation excel engine' do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    before do
      sign_in user
    end

    context 'export translations' do
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

      it 'should have status 200' do
        post 'export_translation_excel'
        File.delete('./file.xlsx')
        expect(response.status).to eq (200)
      end

      it 'should give a csv file in response' do
        post 'export_translation_excel'
        File.delete('./file.xlsx')
        expect(response.headers["Content-Type"]).to eq "application/octet-stream"
        expect(response.headers["Content-Disposition"]).to eq "attachment; filename=\"translations.xlsx\"; filename*=UTF-8''translations.xlsx"
      end

    end
  end

end