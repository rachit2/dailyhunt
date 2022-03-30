require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::LanguagesController, type: :controller do

  describe 'language controller methods' do

    let!(:account) { FactoryBot.create(:account) }
    let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
    describe 'get #index' do
      let!(:language) { FactoryBot.create(:language,is_content_language: true) }
      let(:observed_response_json) do
        {
          "data" => [
            {
              "id" => language.id.to_s,
              "type"=> "language",
              "attributes"=> {
                "id" => language.id,
                "name"=> language.name,
                "language_code" => language.language_code,
                "created_at" => language.created_at.as_json,
                "updated_at" => language.updated_at.as_json,
                "count"=> nil
              }
            }
          ]
        }
      end
      context 'when languages are available' do

        it 'request should have status code 200' do
          get :index
          expect(response).to have_http_status(200)
        end

        it 'should return expected response' do
          get :index, params: { type: "content_languages" }
          response_json = JSON.parse(response.body)
          expect(response_json["data"]).to eq (observed_response_json["data"])
        end
      end
    end

    describe 'post #set_app_language' do
      let!(:language) { FactoryBot.create(:language,is_app_language: true) }
      let(:observed_response_json) do
        {
          "data" => {
            "id" => language.id.to_s,
            "type"=> "language",
            "attributes"=> {
              "id" => language.id,
              "name"=> language.name,
              "language_code" => language.language_code,
              "created_at" => language.created_at.as_json,
              "updated_at" => language.updated_at.as_json,
              "count" => nil
            }
          }
        }
      end
      context 'set app language' do
         it 'request should have status code 200' do
          request.headers.merge! ({"token" => auth_token})
          get :set_app_language, params: {app_language_id: language.id}
          expect(response).to have_http_status(200)
        end

        it 'should return expected response' do
          request.headers.merge! ({"token" => auth_token})
          post :set_app_language,params: {app_language_id: language.id}
          response_json = JSON.parse(response.body)
          expect(response_json["data"]).to eq (observed_response_json["data"])
        end

        it 'should return invalid token' do
          post :set_app_language,params: {app_language_id: language.id}
          response_json = JSON.parse(response.body)
          expect(response_json["errors"]).to eq ([{"token"=>"Invalid token"}])
        end

      end
    end

    describe 'get #get all translations' do
      let!(:application_message1){ FactoryBot.create(:application_message, name:'controllers.login.errors.account_not_found', message:'Account not found, or not activated') }
      let!(:application_message2){ FactoryBot.create(:application_message, name:'controllers.login.errors.failed_login', message: 'Login Failed') }
      let!(:application_message3){ FactoryBot.create(:application_message, name:'controllers.login.errors.invalid_type', message: 'Invalid Account Type') }

      def create_hi_translations
        application_message1.update(locale: :hi, message:'Hindi of Account not found, or not activated')
        application_message2.update(locale: :hi, message:'Hindi of Login Failed')
        application_message3.update(locale: :hi, message:'Hindi of Invalid Account Type')
      end

      let(:en_observed_application_messages_serialized_hash) do
        {
          application_message1.name => 'Account not found, or not activated',
          application_message2.name => 'Login Failed',
          application_message3.name => 'Invalid Account Type',
        }
      end

      let(:hi_observed_application_messages_serialized_hash) do
        {
          application_message1.name => 'Hindi of Account not found, or not activated',
          application_message2.name => 'Hindi of Login Failed',
          application_message3.name => 'Hindi of Invalid Account Type',
        }
      end

      before(:each) do
        I18n.available_locales = [:en, :hi]
        create_hi_translations
      end

      it 'request should have status code 200' do
        get :get_all_translations
        expect(response).to have_http_status(200)
      end

      it 'should return expected response' do
        get :get_all_translations
        response_json = JSON.parse(response.body)
        expect(response_json).to eq (en_observed_application_messages_serialized_hash)
      end

      it 'should return expected response for en' do
        get :get_all_translations, params: { language: :en }
        response_json = JSON.parse(response.body)
        expect(response_json).to eq (en_observed_application_messages_serialized_hash)
      end

      it 'should return expected response for hi' do
        get :get_all_translations, params: { language: :hi }
        response_json = JSON.parse(response.body)
        expect(response_json).to eq (hi_observed_application_messages_serialized_hash)
      end
    end

    describe 'get #last_transaction_time' do
      let!(:application_message) { FactoryBot.create(:application_message) }
      let!(:expected_response) { {"last_transation_time": application_message.updated_at} }
      context 'get last transaction time ' do
        it 'request should have status code 200' do
          get :last_translation_time
          expect(response).to have_http_status(200)
        end
        it 'request should return expected response' do
          get :last_translation_time
          response_json = JSON.parse(response.body)
          expect(response_json).to eq(expected_response.as_json)
        end
      end
    end

    describe 'put #update' do
      let!(:languages) { FactoryBot.create_list(:language,2) }
      it 'returns successful response' do
        request.headers.merge!({"token" => auth_token})
        put :update,params: {id: languages.first.id, languages_ids: [languages.first.id,languages.second.id]}
        expect(response).to have_http_status(200)
      end
      it 'should return invalid token ' do
        put :update,params: {id: languages.first.id, languages_ids: [languages.first.id,languages.second.id]}
        response_json = JSON.parse(response.body)
        expect(response_json["errors"]).to eq ([{"token"=>"Invalid token"}])
      end
    end
  end

end
