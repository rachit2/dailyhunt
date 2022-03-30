require 'rails_helper'

RSpec.describe BxBlockCommunityforum::QuestionsController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:question) { FactoryBot.create(:question, account_id: account.id)}

  let(:observed_response_json) do
    {
      "data" => [
        {
          "id" => question.id.to_s,
          "type" => "question",
          "attributes" => {
            "id" => question.id,
            "title" => question.title,
            "description" => question.description,
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
            "sub_category"=>{
              "id"=> question.sub_category.id,
              "name"=> question.sub_category.name,
              "created_at"=> question.sub_category.created_at.as_json,
              "updated_at"=> question.sub_category.created_at.as_json,
              "parent_id"=>question.sub_category.parent_id,
              "rank"=> question.sub_category.rank
            },
            "image"=>question.image_url,
            "view"=> question.view,
            "tags"=> [],
            "status"=> question.status,
            "votes_count"=>0,
            "likes_count"=> question.likes_count,
            "dislikes_count"=> question.dislikes_count,
            "comments_count"=> question.comments_count,
            "is_popular"=> question.is_popular,
            "is_trending"=> question.is_trending,
            "closed"=> question.closed,
            "created_at"=> question.created_at.as_json,
            "updated_at"=> question.updated_at.as_json,
            "answers"=>[],
            "comments"=>[],
            "user_image"=> question.account.image&.image_url,
            "is_like"=>false
          }
        }
      ]
    }
  end

  let(:attrs) do
    {
      "title" => "title",
      "description" => "description",
      "sub_category_id" => question.sub_category.id,
      "status" => question.status,
      "closed" => "false"
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
          "id" => question.id.to_s,
          "type" => "question",
          "attributes" => {
            "id" => question.id,
            "title" => question.title,
            "description" => question.description,
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
            "sub_category"=>{
              "id"=> question.sub_category.id,
              "name"=> question.sub_category.name,
              "created_at"=> question.sub_category.created_at.as_json,
              "updated_at"=> question.sub_category.updated_at.as_json,
              "parent_id"=>question.sub_category.parent_id,
              "rank"=> question.sub_category.rank
            },
            "image"=>question.image_url,
            "view"=> question.view,
            "tags"=> [],
            "status"=> question.status,
            "votes_count"=> question.votes.count,
            "likes_count"=> question.likes_count,
            "dislikes_count"=> question.dislikes_count,
            "comments_count"=> question.comments_count,
            "closed"=> question.closed,
            "is_popular"=> question.is_popular,
            "is_trending"=> question.is_trending,
            "created_at"=> question.created_at.as_json,
            "updated_at"=> question.updated_at.as_json,
            "answers"=>[],
            "comments"=>[],
            "user_image"=> question.account.image&.image_url,
            "is_like"=>false
          }
        }
      }
    end

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: question.id}
      expect(response).to have_http_status(200)
    end

    it 'request should have same content data' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: question.id}
      question.reload
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json_show)
    end

    it "should return error record not found" do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: -100}
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to eq(["Record not found"])
    end

    describe 'create' do
      it 'should have status 201' do
        request.headers.merge! ({"token" => auth_token})
        post :create, params: {question: attrs, account_id: account.id}
        expect(response.status).to eq 201
      end

      it 'should return error content provider with this account is already taken' do
        request.headers.merge! ({"token" => auth_token})
        attrs["sub_category_id"] = nil
        post :create, params: {question: attrs, account_id: account.id}
        json_response = JSON.parse(response.body)
        expect(response.status).to eq 422
        expect(json_response["error"]).to eq("Sub Category not found")
      end
    end
  end
end
