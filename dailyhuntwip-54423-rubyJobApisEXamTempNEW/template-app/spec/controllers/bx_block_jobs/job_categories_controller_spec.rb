require 'rails_helper'

RSpec.describe BxBlockJobs::JobCategoriesController, type: :controller do

  let!(:category) { FactoryBot.create(:job_category) }
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
      get :show, params:{id: category.id}
      expect(response).to have_http_status(200)
    end
  end

end