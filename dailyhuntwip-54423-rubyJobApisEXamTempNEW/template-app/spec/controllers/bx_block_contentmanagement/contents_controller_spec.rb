require 'rails_helper'

RSpec.describe BxBlockContentmanagement::ContentsController, type: :controller do
  let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
  let!(:content) { FactoryBot.create(:content, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description}, tag_list: "audio")}

  let(:observed_response_json) do
    {
      "data" => [
        serialize_content(content)
      ],
      "is_next" => false,
      "total_pages" => 1
    }
  end

  def serialize_audio_podcast(cont)
    {
      "id"=>cont.contentable.id,
      "heading"=> cont.contentable.heading,
      "description"=>cont.contentable.description,
      "category"=>category_content(cont),
      "sub_category"=>sub_category_content(cont),
      "follow"=>nil,
      "tag_list"=> cont.tag_list,
      "is_popular"=>cont.is_popular,
      "is_trending"=>cont.is_trending,
      "image"=> nil,
      "audio"=> nil,
      "created_at"=>cont.contentable.created_at.as_json,
      "updated_at"=>cont.contentable.updated_at.as_json
    }
  end

  def serialize_test(cont)
    {
      "id"=> cont.contentable.id,
      "description"=> cont.contentable.description,
      "created_at"=> cont.contentable.created_at.as_json,
      "updated_at"=> cont.contentable.updated_at.as_json,
    }
  end

  def serialize_epub(cont)
    {
      "id"=>cont.contentable.id,
      "heading"=> cont.contentable.heading,
      "files"=>[],
      "description"=>cont.contentable.description,
      "thumbnail"=>cont.contentable.image&.image_url,
      "is_trending"=> cont.is_trending,
      "is_popular"=> cont.is_popular,
      "created_at"=>cont.contentable.created_at.as_json,
      "updated_at"=>cont.contentable.updated_at.as_json,
      "category"=>category_content(cont),
      "sub_category"=>sub_category_content(cont),
      "follow"=>nil,
      "tag_list"=> cont.tag_list
    }
  end

  def serialize_videos(cont)
    {
      "id"=> cont.contentable.id,
      "separate_section"=> cont.contentable.separate_section,
      "headline"=> cont.contentable.headline,
      "description"=> cont.contentable.description,
      "thumbnails"=>nil,
      "image"=>nil,
      "video"=>nil,
      "created_at"=> cont.contentable.created_at.as_json,
      "updated_at"=> cont.contentable.updated_at.as_json
    }
  end

  def serialize_text(cont)
    {
      "id"=> cont.contentable.id,
      "headline"=> cont.contentable.headline,
      "content"=> cont.contentable.content,
      "images"=>[],
      "videos"=>[],
      "hyperlink"=>nil,
      "affiliation"=>nil,
      "created_at"=> cont.contentable.created_at.as_json,
      "updated_at"=>cont.contentable.updated_at.as_json
    }
  end

  def serialize_live_stream(cont)
    {
      "id"=> cont.contentable.id,
      "headline"=> cont.contentable.headline,
      "url"=> cont.contentable.url,
      "image_url"=> cont.contentable.image&.image_url,
      "created_at"=> cont.contentable.updated_at.as_json,
      "updated_at"=>cont.contentable.updated_at.as_json,
    }
  end

  def serialize_contentable(cont)
    case cont.content_type.type
    when "Live Stream"
      serialize_live_stream(cont)
    when "Videos"
      serialize_videos(cont)
    when "Text"
      serialize_text(cont)
    when "AudioPodcast"
      serialize_audio_podcast(cont)
    when "Test"
      serialize_test(cont)
    when "Epub"
      serialize_epub(cont)
    end
  end

  def category_content(cont)
    {
      "id"=>cont.category.id,
      "name"=>cont.category.name,
      "created_at"=>cont.category.created_at.as_json,
      "updated_at"=>cont.category.updated_at.as_json,
      "admin_user_id"=>nil,
      "rank"=>cont.category.rank,
      "light_icon"=> {"url"=> cont.category.light_icon_url},
      "light_icon_active"=> {"url"=> cont.category.light_icon_active_url},
      "light_icon_inactive"=> {"url"=> cont.category.light_icon_inactive_url},
      "dark_icon"=> {"url"=> cont.category.dark_icon_url},
      "dark_icon_active"=> {"url"=> cont.category.dark_icon_active_url},
      "dark_icon_inactive"=> {"url"=> cont.category.dark_icon_inactive_url},
      "identifier"=>cont.category.identifier
    }
  end

  def sub_category_content(cont)
    {
      "id"=>cont.sub_category.id,
      "name"=>cont.sub_category.name,
      "created_at"=>cont.sub_category.created_at.as_json,
      "updated_at"=>cont.sub_category.updated_at.as_json,
      "parent_id"=>nil,
      "rank"=>cont.sub_category.rank
    }
  end

  def serialize_content(cont)
    {
      "id"=> cont.id.to_s,
      "type"=>"content",
      "attributes"=>
      {
        "id"=>cont.id,
        "name"=> cont.name,
        "description"=>cont.description,
        "image"=>cont.image,
        "video"=>cont.video,
        "audio"=>cont.audio,
        "study_material"=>cont.study_material,
        "category"=>category_content(cont),
        "sub_category"=>sub_category_content(cont),
        "language"=>
        {
          "id"=>cont.language.id,
          "name"=>cont.language.name,
          "language_code"=>cont.language.language_code,
          "created_at"=>cont.language.created_at.as_json,
          "updated_at"=>cont.language.updated_at.as_json,
          "is_content_language"=>cont.language.is_content_language,
          "is_app_language"=>cont.language.is_app_language
        },
        "content_type"=> {
          "id"=> cont.content_type.id,
          "name"=> cont.content_type.name,
          "type"=> cont.content_type.type,
          "created_at"=> cont.content_type.created_at.as_json,
          "updated_at"=>cont.content_type.updated_at.as_json,
          "identifier"=>nil,
          "rank"=>cont.content_type.rank
        },
        "contentable"=> {
          "data" => {
            "id" => cont.contentable.id.to_s,
            "type"=> cont.contentable.class.name.demodulize.underscore,
            "attributes"=> serialize_contentable(cont)
          }
        },
        "feature_article"=> cont.feature_article,
        "feature_video"=> cont.feature_video,
        "is_trending" => cont.is_trending,
        "is_popular" => cont.is_popular,
        "tag_list" => cont.tag_list,
        "status" => cont.status,
        "publish_date" => cont.publish_date.as_json,
        "view_count" => cont.view_count,
        "is_popular" => cont.is_popular,
        "is_trending" => cont.is_trending,
        "created_at" => cont.created_at.as_json,
        "updated_at" => cont.updated_at.as_json,
        "bookmark" => nil,
        "follow" => nil,
        "content_provider" => nil
      }
    }
  end

  describe '#get_content_detail' do
    it 'request should have status code 200' do
      get :get_content_detail, params: { id: content.content_type_id }
      expect(response.status).to eq(200)
    end
  end

  describe 'index', search: true do
    it 'request should have status code 200' do
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of contents' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same content data' do
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end

    context 'when content type is test' do
      let(:test1) { FactoryBot.create(:test)}
      let(:content_type) { FactoryBot.create(:content_type, type: "Test") }
      let!(:content1) { FactoryBot.create(:content, content_type_id: content_type.id, contentable_attributes: {description:  test1.description, headline: test1.headline}, tag_list: "test")}


      let(:observed_response_json_test) do
        observed_response_json["data"].push(*[
          serialize_content(content1)
        ])
        observed_response_json
      end

      it 'request should have same test content type' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(observed_response_json_test)
      end
    end

    context 'when content type is epub' do
      let(:epub) { FactoryBot.create(:epub)}
      let(:content_type) { FactoryBot.create(:content_type, type: "Epub") }
      let!(:content2) { FactoryBot.create(:content, content_type_id: content_type.id, contentable_attributes: {heading: epub.heading, description:  epub.description}, tag_list: "epub")}

      let(:observed_response_json_epub) do

        observed_response_json["data"].push(*[
          serialize_content(content2)
        ])
        observed_response_json
      end

      it 'request should have same epub content type' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(observed_response_json_epub)
      end
    end

    context 'filter and search' do
      let!(:content_videos) { FactoryBot.create(:content_video)}
      let!(:content_type1) { FactoryBot.create(:content_type, type: 'Videos')}
      let!(:content_texts) { FactoryBot.create(:content_text)}
      let!(:content_type2) { FactoryBot.create(:content_type, type: 'Text')}
      let!(:live_streams) { FactoryBot.create(:live_stream)}
      let!(:content_type3) { FactoryBot.create(:content_type, type: 'Live Stream')}
      let!(:content1) { FactoryBot.create(:content, category: content.category, sub_category: content.sub_category, content_type: content_type1, contentable_attributes: {separate_section: content_videos.separate_section, headline:  content_videos.headline, description: content_videos.description}, tag_list: "content_videos")}
      let!(:content2) { FactoryBot.create(:content, category: content.category, sub_category: content.sub_category, content_type: content_type2, contentable_attributes: {headline: content_texts.headline, content: content_texts.content}, tag_list: "content_texts")}
      let!(:content3) { FactoryBot.create(:content, category: content.category, content_type: content_type3, contentable_attributes: {headline: live_streams.headline, description: live_streams.description, url: live_streams.url}, tag_list: "live_streams")}
      let!(:content4) { FactoryBot.create(:content, content_type: content.content_type,contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description}, tag_list: "tag1")}

      let(:observed_response_json_filter) do
        observed_response_json["data"].push(*[
          serialize_content(content1),
          serialize_content(content2),
          serialize_content(content3),
          serialize_content(content4),
        ])
        observed_response_json
      end

      it 'request should have status code 200' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'request should return correct no. of contents' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (5)
      end

      it 'request should have same content data' do
        get :index
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(observed_response_json_filter)
      end

      it 'request should have same content data when filter by category' do
        get :index, params: {category: content.category.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (4)
        expect(json_response["data"][0]["attributes"]["category"]["name"]).to eq(content.category.name)
        expect(json_response["data"].pluck("id")).to eq([content.id, content1.id, content2.id, content3.id].map(&:to_s))
      end

      it 'request should have same content data when filter by sub category' do
        get :index, params: {sub_category: content.sub_category.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (3)
        expect(json_response["data"][0]["attributes"]["sub_category"]["name"]).to eq(content.sub_category.name)
        expect(json_response["data"].pluck("id")).to eq([content.id, content1.id, content2.id].map(&:to_s))
      end

      it 'request should have same content data when filter by content type' do
        get :index, params: {content_type: content.content_type.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (2)
        expect(json_response["data"][0]["attributes"]["contentable"]["data"]["attributes"]["heading"]).to eq(content.contentable.heading)
        expect(json_response["data"].pluck("id")).to eq([content.id, content4.id].map(&:to_s))
      end

      it 'request should have same content data when filter by tags' do
        get :index, params: {tag: 'audio'}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
        expect(json_response["data"].pluck("id")).to eq([content.id].map(&:to_s))
      end

      it 'request should have same content data when filter by many' do
        get :index, params: {tag: 'audio', category: content.category.id, sub_category: content.sub_category.id, content_type: content.content_type.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
        expect(json_response["data"].pluck("id")).to eq([content.id].map(&:to_s))
      end

      it 'search by category name keyword' do
        BxBlockContentmanagement::Content.reindex
        BxBlockContentmanagement::Content.searchkick_index.refresh
        get :index, params: {search: content.category.name}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (4)
        expect(json_response["data"].pluck("id")).to eq([content.id, content1.id, content2.id, content3.id].map(&:to_s))
      end

      it 'search by sub category name keyword' do
        BxBlockContentmanagement::Content.reindex
        BxBlockContentmanagement::Content.searchkick_index.refresh
        get :index, params: { search: content.sub_category.name }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (3)
        expect(json_response["data"].pluck("id")).to eq([content.id, content1.id, content2.id].map(&:to_s))
      end

      it 'search by content type keyword' do
        BxBlockContentmanagement::Content.reindex
        BxBlockContentmanagement::Content.searchkick_index.refresh
        get :index, params: {search: content.content_type.name}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (2)
        expect(json_response["data"].pluck("id")).to eq([content.id, content4.id].map(&:to_s))
      end

      it 'search by audio podcast heading' do
        BxBlockContentmanagement::Content.reindex
        BxBlockContentmanagement::Content.searchkick_index.refresh
        get :index, params: {search: audio_podcast.heading}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (2)
        expect(json_response["data"].pluck("id")).to eq([content.id, content4.id].map(&:to_s))
      end

      it 'search by audio podcast description' do
        BxBlockContentmanagement::Content.reindex
        BxBlockContentmanagement::Content.searchkick_index.refresh
        get :index, params: {search: audio_podcast.description}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (2)
        expect(json_response["data"].pluck("id")).to eq([content.id, content4.id].map(&:to_s))
      end

      it 'search by keyword' do
        [content_videos.headline, content_videos.description, content_texts.content, content_texts.headline, live_streams.headline, live_streams.description, 'audio', 'content_videos'].each do |keyword|
          BxBlockContentmanagement::Content.reindex
          BxBlockContentmanagement::Content.searchkick_index.refresh
          get :index, params: {search: keyword}
          expect(response).to have_http_status(200)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eq (1)
        end
      end
    end
  end

  describe 'show' do
    let(:observed_response_json_show){{
      "data" => serialize_content(content)
    }}

    it 'request should have status code 200' do
      get :show, params: {id: content.id}
      expect(response).to have_http_status(200)
    end

    it 'request should have same content data' do
      get :show, params: {id: content.id}
      content.reload
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json_show)
    end

    it 'should return nil' do
      get :show, params: {id: -100}
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to eq(nil)
    end
  end
end
