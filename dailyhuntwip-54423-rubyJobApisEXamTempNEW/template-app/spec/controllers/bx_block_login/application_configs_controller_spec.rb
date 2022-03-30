require 'rails_helper'
include ActionDispatch::TestProcess
RSpec.describe BxBlockLogin::ApplicationConfigsController, type: :controller do
  let(:background_file) {  fixture_file_upload(Rails.root.join('spec', 'fixtures', 'short.mov'), 'video/mov') }
  let!(:application_config) { FactoryBot.create(:application_config, login_background_file_attributes: { login_background_file: background_file })}

  let(:observed_response_json) do
    {
      "data" => {
        "id" => application_config.id.to_s,
        "type" => "application_config",
        "attributes" => {
          "home_page_description" => application_config.home_page_description,
          "mime_type" => application_config.mime_type,
          "login_background_file" => application_config.login_background_file.login_background_file_url,
          "created_at" => application_config.created_at.as_json,
          "updated_at" => application_config.updated_at.as_json
        }
      }
    }
  end


  describe '#background_file' do
    it 'request should have status code 200' do
      get :background_file
      expect(response.status).to eq(200)
    end

    it 'request should have same response' do
      get :background_file
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end
end
