require 'rails_helper'

RSpec.describe BxBlockProfile::BoardsController, type: :controller do
  let!(:board) { FactoryBot.create(:board)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> board.id.to_s,
          "type"=> "board",
          "attributes"=> {
              "id"=> board.id,
              "name"=> board.name,
              "rank"=> board.rank
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
