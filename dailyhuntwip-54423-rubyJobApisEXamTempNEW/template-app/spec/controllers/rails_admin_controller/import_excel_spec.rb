require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }

  describe 'import excel engine' do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    before do
      sign_in user
    end

    context 'from admin login' do
      it 'should have status 200' do
        get :import_excel, params: { model_name: 'BxBlockLanguageoptions::ApplicationMessage'}
        expect(response.status).to eq (200)
      end

      it 'should have template import_excel' do
        get :import_excel, params: { model_name: 'BxBlockLanguageoptions::ApplicationMessage'}
        expect(response).to render_template("import_excel")
      end
    end
  end
  
end