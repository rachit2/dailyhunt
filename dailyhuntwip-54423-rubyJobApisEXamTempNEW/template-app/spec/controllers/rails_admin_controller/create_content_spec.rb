require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }
  describe 'create content engine' do
    # let!(:content) {FactoryBot.create(:content, )}
    let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
    let(:category) { FactoryBot.create(:category)}
    let(:sub_category) { FactoryBot.create(:sub_category)}
    let(:language) { FactoryBot.create(:language, name:"english",language_code:"en")}
    let(:content_type) { FactoryBot.create(:content_type)}
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let!(:content) { FactoryBot.create(:content, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description})}

    before(:each) do
      sign_in user
    end

    let(:attrs) do
      {
        "category_id" => category.id,
        "sub_category_id" => sub_category.id,
        "language_id" => language.id,
        "content_type_id" => content_type.id,
        "status" => 'publish',
        "publish_date" => DateTime.now + 1.hour,
        "contentable_attributes" => {
          "heading" =>  audio_podcast.heading,
          "description"  => audio_podcast.description
        }
      }
    end

    let(:update_attibutes) do
      {
        "contentable_attributes" => {
          "heading" =>  "change_attributes"
        }
      }
    end

    describe 'create content' do

      context 'valid create content' do

        it 'should have status 302 for successfully redirect' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(response.status).to eq 302
        end

        it 'should have html content type' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(response.content_type.include?("text/html")).to eq true
        end

        it 'should have flash message' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(flash[:success]).to eq "Content Saved Successfully!"
        end

        it 'user is not login' do
          sign_out user
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
        end

        it 'invalid category' do
          attrs["category_id"] = nil
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(flash["error"]).to eq "Category must exist"
        end

        it 'invalid sub category' do
          attrs["sub_category_id"] = nil
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: attrs}
          expect(flash["error"]).to eq "Sub category must exist"
        end
      end
    end


    describe 'update content' do

      context 'valid update content' do

        it 'should have status 302 for successfully redirect' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(response.status).to eq 302
        end

        it 'should have html content type' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(response.content_type.include?("text/html")).to eq true
        end

        it 'should have flash message' do
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash[:success]).to eq "Content Saved Successfully!"
        end

        it 'user is not login' do
          sign_out user
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
        end

        it 'invalid category' do
          update_attibutes["category_id"] = nil
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash["error"]).to eq "Category must exist"
        end

        it 'invalid sub category' do
          update_attibutes["sub_category_id"] = nil
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash["error"]).to eq "Sub category must exist"
        end

        it 'not save when status is not present' do
          update_attibutes["status"] = nil
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash["error"]).to eq "Status can't be blank"
        end

        it 'invalid status when it change.' do
          update_attibutes["status"] = 'draft'
          post :create_content, params: { model_name: 'BxBlockContentmanagement::Content', bx_block_contentmanagement_content: update_attibutes, content_id: content.id}
          expect(flash["error"]).to eq "Status can't be change to draft."
        end

      end
    end
  end
end
