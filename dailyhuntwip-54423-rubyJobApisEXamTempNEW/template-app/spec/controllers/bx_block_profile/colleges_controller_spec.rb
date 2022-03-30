require 'rails_helper'

RSpec.describe BxBlockProfile::CollegesController, type: :controller do
  let!(:location) { FactoryBot.create(:location) }
  let!(:university) { FactoryBot.create(:university, location: location) }
  let!(:college) { FactoryBot.create(:college, university: university, location: location) }


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> college.id.to_s,
          "type"=> "college",
          "attributes"=> {
              "id"=> college.id,
              "name"=> college.name,
              "is_others"=> college.is_others,
              "rank"=> college.rank
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
