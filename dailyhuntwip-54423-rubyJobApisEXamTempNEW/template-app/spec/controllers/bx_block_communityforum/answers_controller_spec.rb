require 'rails_helper'

RSpec.describe BxBlockCommunityforum::AnswersController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:question) { FactoryBot.create(:question, account_id: account.id)}
  let!(:answer) { FactoryBot.create(:answer, account_id: account.id, question_id: question.id)}


  let(:observed_response_json) do
    {
      "data" => [
        {
          "id" => answer.id.to_s,
          "type" => "answer",
          "attributes" => {
            "id" => answer.id,
            "title" => answer.title,
            "description" => answer.description,
            "account"=>{
              "id" => account.id,
              "first_name" => account.first_name,
              "last_name" => account.last_name,
              "full_phone_number"=>account.full_phone_number, 
              "country_code"=>account.country_code, 
              "phone_number"=>account.phone_number, 
              "email"=>account.email,
              "activated"=>account.activated, 
              "device_id"=>account.device_id,
              "unique_auth_id"=>account.unique_auth_id,
              "password_digest"=>account.password_digest,
              "created_at"=>account.created_at.as_json, 
              "updated_at"=>account.updated_at.as_json,
              "user_name"=>account.user_name,
              "role_id"=>account.role_id,
              "city"=>account.city, 
              "app_language_id"=>account.app_language_id, 
              "last_visit_at"=>account.last_visit_at, 
              "desktop_device_id"=>account.desktop_device_id, 
              "dob"=>account.desktop_device_id,
              "gender"=>account.gender,
              "email_verified"=>account.email_verified,
              "phone_verified"=>account.phone_verified
            },
            "question"=>{
              "id"=> answer.question.id,
              "title" => answer.question.title,
              "description" => answer.question.description,
              "account_id"=> answer.question.account_id,
              "sub_category_id"=> answer.question.sub_category_id,
              "view"=> answer.question.view,
              "status"=>answer.question.status,
              
              "closed"=> answer.question.closed,
              "image"=> {
                "url"=> answer.question.image_url
              },
              "created_at"=> answer.question.created_at.as_json,
              "updated_at"=> answer.question.updated_at.as_json,
              "is_popular"=> answer.question.is_popular,
              "is_trending"=> answer.question.is_trending,
              "tag_list"=> []
            },
            "created_at"=> answer.created_at.as_json,
            "updated_at"=> answer.updated_at.as_json,
            "user_image"=> answer.account.image&.image_url
          }
        }
      ]
    }
  end

  let(:attrs) do
    {
      "title" => "title",
      "description" => "description",
      "question_id" => question.id
    } 
  end

  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of question' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same question data' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end

  describe 'show' do
    let(:observed_response_json_show) do
      {
        "data" =>
        {
          "id" => answer.id.to_s,
          "type" => "answer",
          "attributes" => {
            "id" => answer.id,
            "title" => answer.title,
            "description" => answer.description,
            "account"=>{
              "id" => account.id,
              "first_name" => account.first_name,
              "last_name" => account.last_name,
              "full_phone_number"=>account.full_phone_number, 
              "country_code"=>account.country_code, 
              "phone_number"=>account.phone_number, 
              "email"=>account.email,
              "activated"=>account.activated, 
              "device_id"=>account.device_id,
              "unique_auth_id"=>account.unique_auth_id,
              "password_digest"=>account.password_digest,
              "created_at"=>account.created_at.as_json, 
              "updated_at"=>account.updated_at.as_json,
              "user_name"=>account.user_name,
              "role_id"=>account.role_id,
              "city"=>account.city, 
              "app_language_id"=>account.app_language_id, 
              "last_visit_at"=>account.last_visit_at, 
              "desktop_device_id"=>account.desktop_device_id, 
              "dob"=>account.desktop_device_id,
              "gender"=>account.gender,
              "email_verified"=>account.email_verified,
              "phone_verified"=>account.phone_verified
            },
            "question"=>{
              "id"=> answer.question.id,
              "title" => answer.question.title,
              "description" => answer.question.description,
              "account_id"=> answer.question.account_id,
              "sub_category_id"=> answer.question.sub_category_id,
              "view"=> answer.question.view,
              "status"=>answer.question.status,
              "closed"=> answer.question.closed,
              "image"=> {
                "url"=> answer.question.image_url
              },
              "is_popular"=> answer.question.is_popular,
              "is_trending"=> answer.question.is_trending,
              "created_at"=> answer.question.created_at.as_json,
              "updated_at"=> answer.question.updated_at.as_json,
              "tag_list"=> []
            },
            "created_at"=> answer.created_at.as_json,
            "updated_at"=> answer.updated_at.as_json,
            "user_image"=> answer.account.image&.image_url
          }
        }
      }
    end

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: answer.id}
      expect(response).to have_http_status(200)
    end

    it 'request should have same content data' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: answer.id}
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json_show)
    end

    it "should return error record not found" do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: -100}
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to eq(nil)
    end


    describe 'create' do
      it 'should have status 201' do
        request.headers.merge! ({"token" => auth_token})
        post :create, params: {answer: attrs, account_id: account.id}
        expect(response.status).to eq 201
      end

      it 'should return error content provider with this account is already taken' do
        request.headers.merge! ({"token" => auth_token})
        attrs["question_id"] = nil
        post :create, params: {answer: attrs, account_id: account.id}
        json_response = JSON.parse(response.body)
        expect(response.status).to eq 422
        expect(json_response["error"]).to eq("Question not found")
      end
    end
  end
end
