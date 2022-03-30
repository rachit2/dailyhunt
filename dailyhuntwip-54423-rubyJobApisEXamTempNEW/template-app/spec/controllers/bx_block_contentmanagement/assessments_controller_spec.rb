require 'rails_helper'

RSpec.describe BxBlockContentmanagement::AssessmentsController, type: :controller do

  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token1) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }

  let(:role){FactoryBot.create(:role, name:"partner")}
  let(:partner){ FactoryBot.build(:partner) }
  let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(content_provider.id) }
  let!(:assessment) { FactoryBot.create(:assessment, content_provider: content_provider) }
  let!(:test_question) { FactoryBot.create(:test_question, questionable_id: assessment.id, questionable_type: "BxBlockContentmanagement::Assessment") }
  let!(:option) { FactoryBot.create(:option, test_question_id: test_question.id) }


  let(:observed_response_json) do
    {
      "data" => [
        {
          "id"=> assessment.id.to_s,
          "type"=>"assessment",
          "attributes"=>
          {
            "id"=>assessment.id,
            "heading"=>assessment.heading,
            "timer"=>assessment.timer,
            "description"=>assessment.description,
            "language"=>{
              "id"=>assessment.language.id,
              "name"=>assessment.language.name,
              "language_code"=>assessment.language.language_code,
              "created_at"=>assessment.language.created_at.as_json,
              "updated_at"=>assessment.language.updated_at.as_json,
              "is_content_language"=>assessment.language.is_content_language,
              "is_app_language"=>assessment.language.is_app_language
            },
            "content_provider"=>{
              "id"=>content_provider.id,
              "email"=>content_provider.email,
              "created_at"=>content_provider.created_at.as_json,
              "updated_at"=>content_provider.updated_at.as_json
            },
            "is_popular" => assessment.is_popular,
            "is_trending" => assessment.is_trending,
            "created_at" => assessment.created_at.as_json,
            "updated_at" => assessment.updated_at.as_json,
            "exam"=>nil,
            "test_questions"=> {
              "data" =>[
                {
                  "id" => assessment.test_questions.first.id.to_s,
                  "type"=> "test_question",
                  "attributes" =>{
                    "id"=> assessment.test_questions.first.id,
                    "question"=> assessment.test_questions.first.question,
                    "options_number"=>assessment.test_questions.first.options_number,
                    "options"=>[
                      {
                        "id"=>option.id,
                        "answer"=>option.answer
                      }
                    ],
                    "correct_answer"=>assessment.test_questions.first.correct_ans,
                    "choosen_answer"=>nil
                  }
                }
              ]
            }
          }
        }
      ]
    }
  end

  let(:observed_response_json_show) do
    {
      "data" => {
        "id"=> assessment.id.to_s,
        "type"=>"assessment",
        "attributes"=>
        {
          "id"=>assessment.id,
          "heading"=>assessment.heading,
          "timer"=>assessment.timer,
          "description"=>assessment.description,
          "language"=>{
            "id"=>assessment.language.id,
            "name"=>assessment.language.name,
            "language_code"=>assessment.language.language_code,
            "created_at"=>assessment.language.created_at.as_json,
            "updated_at"=>assessment.language.updated_at.as_json,
            "is_content_language"=>assessment.language.is_content_language,
            "is_app_language"=>assessment.language.is_app_language
          },
          "content_provider"=>{
            "id"=>content_provider.id,
            "email"=>content_provider.email,
            "created_at"=>content_provider.created_at.as_json,
            "updated_at"=>content_provider.updated_at.as_json
          },
          "is_popular" => assessment.is_popular,
          "is_trending" => assessment.is_trending,
          "created_at" => assessment.created_at.as_json,
          "updated_at" => assessment.updated_at.as_json,
          "exam"=>nil,
          "test_questions"=> {
            "data" =>[
              {
                "id" => assessment.test_questions.first.id.to_s,
                "type"=> "test_question",
                "attributes" =>{
                  "id"=> assessment.test_questions.first.id,
                  "question"=> assessment.test_questions.first.question,
                  "options_number"=>assessment.test_questions.first.options_number,
                  "options"=>[
                    {
                      "id"=>option.id,
                      "answer"=>option.answer
                    }
                  ],
                  "correct_answer"=>assessment.test_questions.first.correct_ans,
                  "choosen_answer"=>nil
                }
              }
            ]
          }
        }
      }
    }
  end

  let(:assessment_create_params) do
    {
      "data"=>{
        "heading"=> " assessment",
        "description"=> "description",
        "language_id"=> assessment.language.id,
        "category_id"=> assessment.category.id,
        "sub_category_id"=> assessment.sub_category.id,
        "timer"=> "10=>50",
        "is_popular"=> false,
        "is_trending"=> true,
        "test_questions_attributes"=>[
          {
            "question"=> "first question",
            "options_number"=> 2,
            "options_attributes"=> [
                {
                    "answer"=>"first answer",
                    "description"=> "",
                    "is_right"=> false
                },
                {
                    "answer"=>"second answer",
                    "description"=> "this is right anser",
                    "is_right"=> true
                }
            ]
          }
        ]
      }
    }
  end

  let(:assessment_update_params) do
    {
      "heading"=> "assessment"
    }
  end

  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of content providers' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same content provider data' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end

    context 'filters' do
      it 'request should have status code 200 with category filter' do
        request.headers.merge! ({"token" => auth_token})
        get :index, params: { category: [assessment.category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
      end

      it 'request should have status code 200 with sub_category filter' do
        request.headers.merge! ({"token" => auth_token})
        get :index, params: { sub_category: [assessment.sub_category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response["data"].count).to eq (1)
      end
    end
  end

  describe 'show' do
    it 'request should have status code 200' do
      get :show, params: {id: assessment.id}
      expect(response).to have_http_status(200)
    end

    it 'should return expected response' do
      get :show, params: {id: assessment.id}
      response_json = JSON.parse(response.body)
      expect(response_json).to eq (observed_response_json_show)
    end

    it 'should return nil' do
      get :show, params: {id: 100000}
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to eq(nil)
    end
  end

  describe 'put #update' do
    it 'returns successful response' do
      request.headers.merge!({"token" => auth_token})
      put :update, params: {id: assessment.id, data: assessment_update_params}
      expect(response).to have_http_status(200)
    end
    it 'should return same response ' do
      request.headers.merge!({"token" => auth_token})
      put :update, params: {id: assessment.id, data: assessment_update_params}
      response_json = JSON.parse(response.body)
      expect(response_json["data"]["attributes"]["heading"]).to eq (assessment_update_params["heading"])
    end
  end

  describe 'create' do
    it 'should have status 201' do
      request.headers.merge! ({"token" => auth_token})
      post :create, params: { data: assessment_create_params["data"] }
      expect(response.status).to eq 201
    end

    it 'should return error ' do
      request.headers.merge! ({"token" => auth_token1})
      assessment_create_params["data"]["heading"] = nil
      post :create, params: {data: assessment_create_params["data"] }
      json_response = JSON.parse(response.body)
      expect(response.status).to eq 422
    end
  end
end
