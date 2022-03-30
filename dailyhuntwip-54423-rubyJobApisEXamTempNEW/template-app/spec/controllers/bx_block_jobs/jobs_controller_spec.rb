require 'rails_helper'

RSpec.describe BxBlockJobs::JobsController, type: :controller do
  let!(:job_category) {FactoryBot.create(:job_category)}
  let!(:job) { FactoryBot.create(:job, job_category:job_category) }
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }

  describe 'index' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :show, params:{id: job.id}
      expect(response).to have_http_status(200)
    end
  end

  describe 'apply_job' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      post :apply_job, params:{id:job.id}
      expect(response).to have_http_status(200)
    end
  end

  describe 'my_jobs' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :my_jobs
      expect(response).to have_http_status(200)
    end
  end

  describe 'job_type_and_experience' do
    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :job_type_and_experience
      expect(response).to have_http_status(200)
    end
  end
end
