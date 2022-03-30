# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BxBlockContentmanagement::Exams', type: :request do
  # creating role partner
  let(:role) { FactoryBot.create(:role, name: 'partner') }
  let(:partner) { FactoryBot.build(:partner) }
  # creating partner user
  let!(:content_provider) do
    FactoryBot.create(:admin_user, email: 'partner@careerhunt.com', role: role, partner: partner)
  end
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(content_provider.id) }
  # first exam and its updates and sections
  let!(:exam1) { FactoryBot.create(:exam, content_provider: content_provider) }
  let!(:exam1_updates) { FactoryBot.create(:exam_update, exam: exam1) }
  let!(:exam1_sections) { FactoryBot.create(:exam_section, exam: exam1) }
  # second exam and its updates and sections
  let!(:exam2) { FactoryBot.create(:exam, content_provider: content_provider) }
  let!(:exam2_updates) { FactoryBot.create(:exam_update, exam: exam2) }
  let!(:exam2_sections) { FactoryBot.create(:exam_section, exam: exam2) }
  # index url
  let(:listing_url) { '/bx_block_contentmanagement/exams' }
  # seting headers
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'token' => auth_token.to_s
    }
  end

  describe 'GET /bx_block_contentmanagement/exams' do
    before do
      get listing_url, headers: headers
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all exams' do
      expect(JSON.parse(response.body)['data'].count).to eq(BxBlockContentmanagement::Exam.count)
    end
  end

  describe 'User can view details of one exam' do
    before do
      get "/bx_block_contentmanagement/exams/#{exam1.id}", headers: headers
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return the exam info, exam updates info and exam sections info' do
      expect(JSON.parse(response.body)['data']['attributes']['heading']).to eq(exam1.heading)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(exam1.description)
      expect(JSON.parse(response.body)['data']['attributes']['exam_updates']['data']).not_to be_empty
      expect(JSON.parse(response.body)['data']['attributes']['exam_sections']['data']).not_to be_empty
    end
  end
end
