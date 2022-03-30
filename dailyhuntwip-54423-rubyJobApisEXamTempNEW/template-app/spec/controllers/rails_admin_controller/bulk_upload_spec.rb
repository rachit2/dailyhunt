require 'rails_helper'

RSpec.describe RailsAdmin::MainController, type: :controller do

  routes { RailsAdmin::Engine.routes }

  describe 'send excel engine' do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let!(:role1){FactoryBot.create(:role, name:"partner")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}
    let!(:content_type1) { FactoryBot.create(:content_type, name: "News Articles", type: "Text", identifier: "news_article")}
    let!(:content_type2) { FactoryBot.create(:content_type, name: "Blogs", type: "Text", identifier: "blog")}
    let!(:content_type3) { FactoryBot.create(:content_type, name: "Videos (short)", type: "Videos", identifier: "video_short")}
    let!(:content_type4) { FactoryBot.create(:content_type, name: "Videos (full length)", type: "Videos", identifier: "video_full")}
    let!(:content_type5) { FactoryBot.create(:content_type, name: "Live Streaming", type: "Live Stream", identifier: "live_streaming")}
    let!(:content_type6) { FactoryBot.create(:content_type, name: "Audio Podcast", type: "AudioPodcast", identifier: "audio_podcast")}
    let!(:content_type9) { FactoryBot.create(:content_type, name: "Study Materials (PDFs/ PPTs/ Word)", type: "Epub", identifier: "study_material")}
    let!(:language) { FactoryBot.create(:language, name: "english", language_code: "en", is_content_language: true) }
    let!(:author) {FactoryBot.create(:author, id: 1)}

    before do
      sign_in user
    end

    context 'save translations' do

      it 'should have status 302 and show flash message' do
        load Rails.root + "db/seeds.rb"
        post 'bulk_upload', params: { upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/ContentData.xlsx") }
        expect(flash[:success]).to eq "Sucessfully imported data "
        expect(response.status).to eq (302)
        expect(response).to redirect_to('/admin/import_data')
      end

    end
  end
  
end
