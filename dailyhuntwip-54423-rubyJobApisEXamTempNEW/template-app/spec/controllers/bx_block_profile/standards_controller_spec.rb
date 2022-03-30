require 'rails_helper'

RSpec.describe BxBlockProfile::StandardsController, type: :controller do
  let!(:standard) { FactoryBot.create(:standard)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> standard.id.to_s,
          "type"=> "standard",
          "attributes"=> {
              "id"=> standard.id,
              "name"=> standard.name,
              "rank"=> standard.rank
          }
        }
      ]
    }
  end


  describe 'index' do

    it 'request should have status code 200' do
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should have same data' do
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end
end
