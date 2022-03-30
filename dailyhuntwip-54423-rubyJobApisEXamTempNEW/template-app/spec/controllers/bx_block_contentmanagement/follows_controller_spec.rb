require 'rails_helper'

RSpec.describe BxBlockContentmanagement::FollowsController, type: :controller do

  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
  let(:role){FactoryBot.create(:role, name:"partner")}
  let(:partner){ FactoryBot.build(:partner) }
  let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
  let!(:follow) { FactoryBot.create(:follow, account: account, content_provider: content_provider) }

  before :each do
    BxBlockLanguageoptions::BuildLanguages.call
    BxBlockLanguageoptions::CreateAndUpdateTranslations.call
  end

  let(:observed_response_json) do
    {
      "data" => [
        serialize_content(content_provider)
      ]
    }
  end

  def serialize_content(cont, increment_by_one=nil)
    {
      "id"=> cont.id.to_s,
      "type"=>"content_provider",
      "attributes"=>
      {
        "id"=>cont.id,
        "email"=>cont.email,
        "partner_name"=>cont.partner_name,
        "logo"=>nil,
        "created_at" => cont.created_at.as_json,
        "updated_at" => cont.updated_at.as_json, 
        "follow"=>true,
        "count"=>nil
      }
    }
  end

  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of content providers' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same content provider data' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end

  describe 'create' do
    let(:role){FactoryBot.create(:role, name:"partner")}
    let(:partner){ FactoryBot.build(:partner) }
    let!(:content_provider1){ FactoryBot.create(:admin_user, email:"partner1@careerhunt.com", role:role, partner: partner) }
    it 'should have status 201' do
      request.headers.merge! ({"token" => auth_token})
      post :create, params: {content_provider_id: content_provider1.id, account_id: account.id}
      expect(response.status).to eq 201
    end

    it 'should return error content provider with this account is already taken' do
      request.headers.merge! ({"token" => auth_token})
      post :create, params: {content_provider_id: content_provider.id, account_id: account.id}
      json_response = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(json_response["data"]["attributes"]["errors"]["account_id"]).to eq(["content provider with this account is already taken"])
    end
  end  
end
