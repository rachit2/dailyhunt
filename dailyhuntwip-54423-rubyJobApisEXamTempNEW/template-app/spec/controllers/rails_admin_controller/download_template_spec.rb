require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }

  describe 'download template excel engine' do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    before do
      sign_in user
    end

    context 'download template' do

      it 'should have status 200' do
        post 'download_template'
        expect(response.status).to eq (200)
      end

      it 'should give a csv file in response' do
        post 'download_template'
        expect(response.headers["Content-Type"]).to eq "application/xlsx"
        expect(response.headers["Content-Disposition"]).to eq "attachment; filename=\"ContentData.xlsx\"; filename*=UTF-8''ContentData.xlsx"
      end

    end
  end

end