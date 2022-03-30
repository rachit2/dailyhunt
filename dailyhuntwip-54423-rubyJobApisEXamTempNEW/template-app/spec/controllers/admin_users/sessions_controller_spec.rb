require 'rails_helper'

RSpec.describe AdminUsers::SessionsController, type: :controller do
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin_user]
  end

  describe 'new' do
    context 'when user is super admin' do
      it 'should have status 200' do
        get :new
        expect(response.status).to eq 200
      end

      it 'should have html content type' do
        get :new
        expect(response.content_type.include?("text/html")).to eq true
      end
    end
  end

  describe 'create' do
    context 'when user is super admin' do
      let(:role){FactoryBot.create(:role, name:"super_admin")}
      let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
      let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

      let(:attrs) do
        {
          "email" => user.email,
          "password" => "careerhunt@321"
        }
      end

      it 'should have status 302' do
        post :create, params: { admin_user: attrs}
        expect(response.status).to eq 302
      end

      it 'should have sign in flash message' do
        post :create, params: { admin_user: attrs}
        expect(flash[:notice]).to eq "Signed in successfully."
      end

      it 'should redirect to root path' do
        post :create, params: {admin_user: attrs}
        expect(response).to redirect_to(Rails.application.routes.url_helpers.root_path)
      end

      it 'should show error when email is not valid' do
        attrs[:email] = "test@yopmail.com"
        post :create, params: {admin_user: attrs}
        expect(flash[:alert]).to eq "Invalid email or password."
      end

      it 'should show error when password is not valid' do
        attrs["password"] = "1234567"
        post :create, params: {admin_user: attrs}
        expect(flash[:alert]).to eq "Invalid Email or password."
      end
    end

    context 'when partner user is valid' do
      let(:role){FactoryBot.create(:role, name:"partner")}
      let(:partner){ FactoryBot.build(:partner) }
      let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }
      let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

      let(:attrs) do
        {
          "email" => user.email,
          "password" => "careerhunt@321"
        }
      end

      it 'should have status 302' do
        post :create, params: {admin_user: attrs}
        expect(response.status).to eq 302
      end

      it 'should have sign in flash message' do
        post :create, params: {admin_user: attrs}
        expect(flash[:notice]).to eq "Signed in successfully."
      end

      it 'should redirect to root path' do
        post :create, params: {admin_user: attrs}
        expect(response).to redirect_to(Rails.application.routes.url_helpers.root_path)
      end
    end

    context 'when partner user is invalid' do
      let(:role){FactoryBot.create(:role, name:"partner")}
      let(:partner){ FactoryBot.build(:partner, status: "pending") }
      let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }
      let(:user1){ FactoryBot.create(:admin_user, email:"admin@careerhunt1.com", role:role, partner: partner) }

      let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

      let(:attrs) do
        {
          "email" => user.email,
          "password" => "careerhunt@321"
        }
      end

      it 'should show error when email is not valid' do
        attrs[:email] = "test@yopmail.com"
        post :create, params: {admin_user: attrs}
        expect(flash[:alert]).to eq "Invalid email or password."
      end

      it 'should show error when password is not valid' do
        attrs["password"] = "1234567"
        post :create, params: {admin_user: attrs}
        expect(flash[:alert]).to eq "Invalid Email or password."
      end

      it 'should show error when status is pending' do
        post :create, params: {admin_user: attrs}
        expect(flash[:danger]).to eq "your status is not approved"
      end

      it 'should have status 302' do
        post :create, params: {admin_user: attrs}
        expect(response.status).to eq 302
      end

      it 'should redirect to sign in path' do
        post :create, params: {admin_user: attrs}
        expect(response).to redirect_to(Rails.application.routes.url_helpers.admin_user_session_path)
      end
    end

    context 'when user is partner valid but already sign in' do
      let(:role){FactoryBot.create(:role, name:"partner")}
      let(:partner){ FactoryBot.build(:partner) }
      let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }
      let(:user1){ FactoryBot.create(:admin_user, email:"admin@careerhunt1.com", role:role, partner: partner) }
      let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

      let(:admin_user_role1){FactoryBot.create(:admin_user_role, admin_user: user1, role: role)}

      let(:attrs) do
        {
          "email" => user.email,
          "password" => "careerhunt@321"
        }
      end

      before(:each) do
        sign_in user1
      end

      it 'should show error when user is already sign in' do
        post :create, params: {admin_user: attrs}
        expect(flash[:danger]).to eq "Please log out first before you proceed."
      end
    end
  end
end
