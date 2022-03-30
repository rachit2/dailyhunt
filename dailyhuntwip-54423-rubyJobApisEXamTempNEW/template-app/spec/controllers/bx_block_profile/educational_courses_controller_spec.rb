require 'rails_helper'

RSpec.describe BxBlockProfile::EducationalCoursesController, type: :controller do
  let!(:educational_course) { FactoryBot.create(:educational_course)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> educational_course.id.to_s,
          "type"=> "educational_course",
          "attributes"=> {
              "id"=> educational_course.id,
              "name"=> educational_course.name,
              "rank"=> educational_course.rank
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
