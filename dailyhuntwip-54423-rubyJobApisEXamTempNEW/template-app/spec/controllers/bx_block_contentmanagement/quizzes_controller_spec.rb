require 'rails_helper'

RSpec.describe BxBlockContentmanagement::QuizzesController, type: :controller do

  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let(:role){FactoryBot.create(:role, name:"partner")}
  let(:partner){ FactoryBot.build(:partner) }
  let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
  let(:content_provider_token) { BuilderJsonWebToken::JsonWebToken.encode(content_provider.id) }
  let!(:quiz) { FactoryBot.create(:quiz) }
  let!(:test_question) { FactoryBot.create(:test_question, questionable: quiz) }
  let!(:option) { FactoryBot.create(:option, test_question: test_question) }

  let(:observed_response_json) do
    {
      "data"=>[
        {
          "id"=>quiz.id.to_s,
          "type"=>"quiz",
          "attributes"=>{
            "id"=>quiz.id,
            "heading"=>quiz.heading,
            "description"=>quiz.description,
            "quiz_description"=> quiz.quiz_description,
            "language"=>{
              "data"=>{
                "id"=>quiz.language_id.to_s,
                "type"=>"language",
                "attributes"=>{
                  "id"=>quiz.language_id,
                  "name"=>quiz.language.name,
                  "language_code"=>quiz.language.language_code,
                  "created_at"=>quiz.language.created_at.as_json,
                  "updated_at"=>quiz.language.updated_at.as_json,
                  "count"=>nil
                }
              }
            },
            "content_provider"=> quiz.content_provider,
            "timer"=>quiz.timer,
            "test_questions"=>{
              "data"=>[
                {
                  "id"=>quiz.test_questions.first.id.to_s,
                  "type"=>"test_question",
                  "attributes"=>{
                    "id"=>quiz.test_questions.first.id,
                    "question"=>quiz.test_questions.first.question,
                    "options_number"=>quiz.test_questions.first.options_number,
                    "options"=>[
                      {
                        "id"=>option.id,
                        "answer"=>option.answer
                      }
                    ],
                    "correct_answer"=> quiz.test_questions.first.correct_ans,
                    "choosen_answer"=> nil             
                  }
                }
              ]
            },
            "is_popular"=>quiz.is_popular,
            "is_trending"=>quiz.is_trending,
            "created_at"=>quiz.created_at.as_json,
            "updated_at"=>quiz.updated_at.as_json
          }
        }
      ]
    }
  end

  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of content providers' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have some quizzes' do
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end

    context 'filters' do
      it 'request should have status code 200 with category filter' do
        request.headers.merge! ({"token" => auth_token})
        get :index, params: { category: [quiz.category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
      end

      it 'request should have status code 200 with sub_category filter' do
        request.headers.merge! ({"token" => auth_token})
        get :index, params: { sub_category: [quiz.sub_category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
      end
    end
  end

  describe 'create' do
    it 'should have status 200' do
      request.headers.merge! ({"token" => content_provider_token})
      post :create, params: {data: {heading: quiz.heading, description: quiz.description, quiz_description: quiz.quiz_description, language_id: quiz.language_id, is_popular: quiz.is_popular, is_trending: quiz.is_trending, timer: quiz.timer, category_id: quiz.category_id, sub_category_id: quiz.sub_category_id}}
      expect(response.status).to eq 200
    end
  end

  describe 'home quizzes' do
    it 'should have some quizzes' do
      get :home_quizzes
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
    end
  end

  describe 'create, update question and content provider quizzes' do
    let!(:quiz1) { FactoryBot.create(:quiz, content_provider_id: content_provider.id) }
    let!(:test_question1) { FactoryBot.create(:test_question, questionable: quiz1) }
    it 'should have status 200' do
      request.headers.merge! ({"token" => content_provider_token})
      post :create_question, params: {id: quiz1.id, data: {question: test_question.question, options_number: test_question.options_number, options_attributes:[answer: option.answer, description: option.description, is_right: option.is_right] }}
      expect(response.status).to eq 200
    end

    it 'should have status 200 in update question' do
      request.headers.merge! ({"token" => content_provider_token})
      post :update_question, params: {id: quiz1.id, test_question_id: test_question1.id, data: {question: test_question1.question, options_number: test_question1.options_number, options_attributes:[answer: option.answer, description: option.description, is_right: option.is_right] }}
      expect(response.status).to eq 200
    end

    it 'should return content provider quizzes' do
      request.headers.merge! ({"token" => content_provider_token})
      get :myquizzes
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end
  end

end
