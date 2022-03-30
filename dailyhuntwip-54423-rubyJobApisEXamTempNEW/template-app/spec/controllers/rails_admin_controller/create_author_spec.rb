require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }
  describe 'create content engine' do

    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com") }

    before(:each) do
      sign_in user
    end

    let(:attrs) do
      {
        "author[bio]" => "author bio",
        "author[name]" => "author name"
      }
    end

    let(:wrong_attrs) do
      {
        "author[bio]" => "",
        "author[name]" => ""
      }
    end

    describe 'create content' do

      context 'valid create content' do

        it 'should have status 200' do
          post :create_author, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(response.status).to eq 200
        end

        it 'should have status 422 when pass wrong attributes.' do
          post :create_author, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: wrong_attrs}
          expect(response.status).to eq 422
        end

      end
    end



  end
end
