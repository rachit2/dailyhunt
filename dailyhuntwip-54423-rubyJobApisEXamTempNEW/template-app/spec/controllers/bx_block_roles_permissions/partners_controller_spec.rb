require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::PartnersController, type: :controller do
  let!(:role) { FactoryBot.create(:role, name: "partner")}
  let(:category) { FactoryBot.create(:category)}
  let(:sub_category) { FactoryBot.create(:sub_category)}
  let(:content_type) { FactoryBot.create(:content_type)}

  let(:attrs) do
    {
      "email" => "test@yopmail.com",
      "partner_attributes" => {
        "name" => "partner name",
        "address" => "partner address",
        "spoc_name" => "partner spoc name",
        "spoc_contact" => "87312234343",
        "category_ids"=> [category.id],
        "sub_category_ids" => [sub_category.id],
        "content_type_ids" => [content_type.id],
      }
    }
  end

  describe 'new partner' do
    context 'new partner form' do

      it 'should have status 200' do
        get :new
        expect(response.status).to eq 200
      end

      it 'should have html content type' do
        get :new
        expect(response.content_type.include?("text/html")).to eq true
      end

      it 'should have action of create partner' do
        get :new
        expect(response.body.include?(Rails.application.routes.url_helpers.bx_block_roles_permissions_partners_path)).to eq true
      end
    end
  end

  describe 'create partner 'do
    context 'create partner' do

      it 'should have status 302' do
        post :create, params: {bx_block_admin_admin_user: attrs}
        expect(response.status).to eq 302
      end

      it 'should have html content type' do
        post :create, params: {bx_block_admin_admin_user: attrs}
        expect(response.content_type.include?("text/html")).to eq true
      end


      it 'should have success flash message' do
        post :create, params: {bx_block_admin_admin_user: attrs}
        expect(flash[:success]).to eq "Partner Signed up Successfully, You will receive an email regarding your registration status!"
      end

      it 'invalid email' do
        attrs["email"] = ""
        post :create, params: {bx_block_admin_admin_user: attrs}
        expect(flash["error"]).to eq "Email can't be blank"
      end

      it 'should redirect to admin user sign in path' do
        post :create, params: {bx_block_admin_admin_user: attrs}
        expect(response.redirect_url.include?(Rails.application.routes.url_helpers.new_admin_user_session_path)).to eq true
      end
    end
  end
end
