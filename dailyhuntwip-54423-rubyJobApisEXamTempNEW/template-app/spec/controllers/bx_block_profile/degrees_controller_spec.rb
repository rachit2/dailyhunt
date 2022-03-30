require 'rails_helper'

RSpec.describe BxBlockProfile::DegreesController, type: :controller do
  let!(:degree) { FactoryBot.create(:degree)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> degree.id.to_s,
          "type"=> "degree",
          "attributes"=> {
              "id"=> degree.id,
              "name"=> degree.name,
              "rank"=> degree.rank
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
