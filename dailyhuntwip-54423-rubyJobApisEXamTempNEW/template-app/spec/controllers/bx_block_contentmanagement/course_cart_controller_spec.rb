require 'rails_helper'

RSpec.describe BxBlockContentmanagement::CourseCartsController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let(:role){FactoryBot.create(:role, name:"partner")}
  let(:partner){ FactoryBot.build(:partner) }
  let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
  let!(:courses) { FactoryBot.create_list(:course, 4, content_provider: content_provider) }

  before(:each) do
    request.headers.merge! ({"token" => auth_token})
  end

  let(:observed_response_json) do
    {
      "data"=> {
        "id"=>account.course_cart.id.to_s,
        "type"=>"course_cart",
        "attributes"=>{
          "id"=>account.course_cart.id,
          "course_ids"=> courses.map(&:id),
          "price" => courses.sum(&:price),
          "courses"=>BxBlockContentmanagement::CourseSerializer.new(courses).as_json,
          "created_at"=>account.course_cart.created_at.as_json,
          "updated_at"=>account.course_cart.updated_at.as_json,
        },
      },
    }
  end

  describe 'create' do
    it 'should have status 200' do
      post :create, params: { data: { course_ids: courses.map(&:id) } }
      expect(response.status).to eq 200
    end

    it 'should return correct response' do
      post :create, params: { data: { course_ids: courses.map(&:id) } }
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response).to eq (observed_response_json)
    end
  end


  describe 'index' do
    before(:each) do
      post :create, params: { data: { course_ids: courses.map(&:id) } }
    end

    it 'request should have status code 200' do
      get :index
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of courses' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end

end
