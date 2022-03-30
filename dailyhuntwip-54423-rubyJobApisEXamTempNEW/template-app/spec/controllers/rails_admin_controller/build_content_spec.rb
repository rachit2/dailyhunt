require 'rails_helper'
#require_relative 'lib/BuildContnt.rb'
RSpec.describe RailsAdmin::MainController, type: :controller do
  
  routes { RailsAdmin::Engine.routes }
  describe 'build content engine' do
    # let!(:content) {FactoryBot.create(:content, )}
    let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
    let!(:content) { FactoryBot.create(:content, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description})}
    

    describe 'build content' do
      let(:role){FactoryBot.create(:role, name:"super_admin")}
      let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
      let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

      before(:each) do
        sign_in user
      end

      context 'new content form' do

        it 'should have status 200' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content'}
          expect(response.status).to eq 200
        end

        it 'should have html content type' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content'}

          expect(response.content_type.include?("text/html")).to eq true
          expect(response.body.include?("/bx_block_contentmanagement~content/build_content")).to eq true

        end

        it 'user is not login' do
          sign_out user
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content'}
          expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
        end
      end

      context 'edit content form' do

        it 'should have status 200 for edit' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content', id: content.id}
          expect(response.status).to eq (200)
        end

        it 'should have content type html' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content', id: content.id}
          expect(response.content_type.include?("text/html")).to eq true
        end

        it 'should have content template path' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content', id: content.id}
          expect(response.body.include?("/bx_block_contentmanagement~content/build_content")).to eq true
        end

        it 'should have same content id' do
          get :build_content, params: { model_name: 'BxBlockContentmanagement::Content', id: content.id}
          expect(response.body.include?(content.id.to_s)).to eq true
        end

        it 'invalid id' do
          expect { BxBlockContentmanagement::Content.find(100) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end