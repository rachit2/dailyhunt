require 'rails_helper'

RSpec.describe BxBlockCommunityforum::CommentsController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:question) { FactoryBot.create(:question, account_id: account.id)}
  let!(:answer) { FactoryBot.create(:answer, account_id: account.id, question_id: question.id)}
  let!(:comment) { FactoryBot.create(:comment, account_id: account.id)}

  let(:observed_response_json) do
    {
      "data" => [
        {
          "id" => comment.id.to_s,
          "type" => "comment",
          "attributes" => {
            "id" => comment.id,
            "description" => comment.description,
            "commentable_id" => comment.commentable.id,
            "commentable_type" => comment.commentable_type,
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
            "likes_count"=>comment.likes_count,
            "dislikes_count"=>comment.dislikes_count,
            "comments_count"=>comment.comments_count,
            "created_at" => comment.created_at.as_json,
            "updated_at" => comment.updated_at.as_json,
            "user_image"=>comment.account.image&.image_url, 
            "is_like"=>false
          }
        }
      ]
    }
  end

  let(:attrs) do
    {
      "description" => "description",
      "commentable_id" => question.id,
      "commentable_type" => "question"
    }
  end

  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of comment' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same comment data' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end

  describe 'create comment' do
    context 'create' do

      it 'should have status 201' do
        request.headers.merge! ({"token" => auth_token})
        post :create, params: {comment: attrs}
        expect(response.status).to eq 201
      end

      it 'should have success true' do
        request.headers.merge! ({"token" => auth_token})
        post :create, params: {comment: attrs}
        expect(JSON.parse(response.body)["meta"]["success"]).to eq(true)
      end
    
      it "commentable must exist" do
        request.headers.merge! ({"token" => auth_token})
        attrs["commentable_id"] = nil
        post :create, params: {comment: attrs}
        json_response = JSON.parse(response.body)
        expect(json_response["meta"][0]["message"][0]["error"]).to eq("Commentable must exist")
      end
    end
  end

  describe 'show' do
    let(:observed_response_json_show) do
      {
        "data" => {
          "id" => comment.id.to_s,
          "type" => "comment",
          "attributes" => {
            "id" => comment.id,
            "description" => comment.description,
            "commentable_id" => comment.commentable.id,
            "commentable_type" => comment.commentable_type,
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
            "likes_count"=>comment.likes_count,
            "dislikes_count"=>comment.dislikes_count,
            "comments_count"=>comment.comments_count,
            "created_at" => comment.created_at.as_json,
            "updated_at" => comment.updated_at.as_json,
            "user_image"=>comment.account.image&.image_url,
            "comments"=>[], 
            "is_like"=>false
          }
        }
      }
    end

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: comment.id}
      expect(response).to have_http_status(200)
    end

    it 'request should have same comment data' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params: {id: comment.id}
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
  end
end
