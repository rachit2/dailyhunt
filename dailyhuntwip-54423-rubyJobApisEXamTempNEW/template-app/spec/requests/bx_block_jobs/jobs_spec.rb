require 'rails_helper'

RSpec.describe "BxBlockJobs::Jobs", type: :request do
	let!(:account) { FactoryBot.create(:account) }
	let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
	let!(:job1) { FactoryBot.create(:job)}
	let!(:job2) { FactoryBot.create(:job)}
	let(:listing_url) { '/bx_block_jobs/jobs' }
	let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'token' => "#{auth_token}",
    }
  end

	describe 'GET /bx_block_jobs/jobs as admin' do
    before do
      get listing_url, headers: headers
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all jobs' do
      expect(JSON.parse(response.body)['data'].count).to eq(BxBlockJobs::Job.count)
    end
  end

  describe 'User can view details of one job record' do
    before do
      get "/bx_block_jobs/jobs/#{job1.id}", headers: headers
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return the job info' do
      expect(JSON.parse(response.body)['data']['attributes']['name']).to eq(job1.name)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(job1.description)
      expect(JSON.parse(response.body)['data']['attributes']['requirement']).to eq(job1.requirement)
      expect(JSON.parse(response.body)['data']['attributes']['job_type']).to eq(job1.job_type)
    end
  end

end
