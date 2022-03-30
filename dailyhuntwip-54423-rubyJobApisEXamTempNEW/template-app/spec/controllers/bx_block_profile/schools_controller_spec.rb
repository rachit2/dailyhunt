require 'rails_helper'

RSpec.describe BxBlockProfile::SchoolsController, type: :controller do
  # let!(:location) { FactoryBot.create(:location) }
  # let!(:university) { FactoryBot.create(:university, location: location) }
  # let!(:school) { FactoryBot.create(:college, university: university, location: location) }
  # let!(:school) { FactoryBot.create(:school) }
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }


  # let(:observed_response_json) do
  #   {
  #     "data"=> [
  #       {
  #         "id"=> college.id.to_s,
  #         "type"=> "college",
  #         "attributes"=> {
  #             "id"=> college.id,
  #             "name"=> college.name,
  #             "is_others"=> college.is_others,
  #             "rank"=> college.rank
  #         }
  #       }
  #     ]
  #   }
  # end

  describe 'index' do

    it 'request should have status code 200' do
      get :index
      expect(response).to have_http_status(200)
    end

    # it 'request should have same data' do
    #   get :index
    #   expect(response).to have_http_status(200)
    #   json_response = JSON.parse(response.body)
    #   expect(json_response).to eq(observed_response_json)
    # end
  end

  describe 'total_fees_list' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :total_fees_list
      expect(response).to have_http_status(200)
    end
  end

end
