require 'rails_helper'

RSpec.describe BxBlockProfile::SubjectsController, type: :controller do
  let!(:subject) { FactoryBot.create(:subject)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> subject.id.to_s,
          "type"=> "subject",
          "attributes"=> {
              "id"=> subject.id,
              "name"=> subject.name,
              "rank"=> subject.rank
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
