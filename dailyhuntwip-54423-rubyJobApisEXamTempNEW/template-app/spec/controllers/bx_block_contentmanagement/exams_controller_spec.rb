# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BxBlockContentmanagement::ExamsController, type: :controller do
  # creating role partner
  let(:role) { FactoryBot.create(:role, name: 'partner') }
  let(:partner) { FactoryBot.build(:partner) }
  # creating partner user
  let!(:content_provider) do
    FactoryBot.create(:admin_user, email: 'partner@careerhunt.com', role: role, partner: partner)
  end

  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(content_provider.id) }
  let!(:exam) do
    FactoryBot.create(:exam, to: Date.today + 2.month, from: Date.today + 1.month, content_provider: content_provider)
  end
  let!(:exam1) { FactoryBot.create(:exam, to: Date.today, from: Date.today, content_provider: content_provider) }

  let(:observed_response_json) do
    {
      "data"=> [
        { 
          "id"=> exam1.id.to_s,
          "type"=> "exam",
          "attributes"=> {
            "id"=> exam1.id,
            "heading"=> exam1.heading,
            "description"=> exam1.description,
            "thumbnail"=>exam1.thumbnail_url,
            "exam_updates"=>{ "data"=>[] },
            "exam_sections"=>{ "data"=>[] },
            "created_at"=> exam1.created_at.as_json,
            "updated_at"=> exam1.updated_at.as_json
          }
        },
        { 
          "id"=> exam.id.to_s,
          "type"=> "exam",
          "attributes"=> {
            "id"=> exam.id,
            "heading"=> exam.heading,
            "description"=> exam.description,
            "thumbnail"=>exam.thumbnail_url,
            "exam_updates"=>{ "data"=>[] },
            "exam_sections"=>{ "data"=>[] },
            "created_at"=> exam.created_at.as_json,
            "updated_at"=> exam.updated_at.as_json
          }
        }
      ]
    }
  end

  describe 'index' do
    it 'request should have status code 200' do
      request.headers.merge!({ 'token' => auth_token })
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of exams' do
      request.headers.merge!({ 'token' => auth_token })
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq(2)
    end

    it 'request should have same exam data' do
      request.headers.merge!({ 'token' => auth_token })
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]&.sort_by{|a|a["id"]}).to eq(observed_response_json["data"]&.sort_by{|a|a["id"]})
    end

    context 'filters' do
      it 'request should have status code 200 with date filter' do
        request.headers.merge!({ 'token' => auth_token })
        get :index, params: { date: { to: Date.today.beginning_of_month.to_s, from: Date.today.end_of_month } }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
      end

      it 'request should have status code 200 with current_month filter' do
        request.headers.merge!({ 'token' => auth_token })
        get :index, params: { current_month: 'true' }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
      end

      it 'request should have status code 200 with category filter' do
        request.headers.merge!({ 'token' => auth_token })
        get :index, params: { category: [exam.category_id, exam1.category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(2)
      end

      it 'request should have status code 200 with sub_category filter' do
        request.headers.merge!({ 'token' => auth_token })
        get :index, params: { sub_category: [exam.sub_category_id, exam1.sub_category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(2)
      end
    end
  end

  describe 'show' do
    let(:observed_response_json_show) do
      {
        'data' => {
          'id' => exam1.id.to_s,
          'type' => 'exam',
          'attributes' => {
            'id' => exam1.id,
            'heading' => exam1.heading,
            'thumbnail' => exam1.thumbnail_url,
            'description' => exam1.description,
            'exam_sections' => { 'data' => [] },
            'exam_updates' => { 'data' => [] },
            'created_at' => exam1.created_at.as_json,
            'updated_at' => exam1.updated_at.as_json
          }
        }
      }
    end
    it 'request should have status code 200' do
      request.headers.merge!({ 'token' => auth_token })
      get :show, params: { id: exam1.id }
      expect(response).to have_http_status(200)
    end

    it 'should return expected response' do
      request.headers.merge!({ 'token' => auth_token })
      get :show, params: { id: exam1.id }
      response_json = JSON.parse(response.body)
      expect(response_json).to eq(observed_response_json_show)
    end

    it 'should return nil' do
      request.headers.merge!({ 'token' => auth_token })
      get :show, params: { id: 100_000 }
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to eq(nil)
    end
  end
end
