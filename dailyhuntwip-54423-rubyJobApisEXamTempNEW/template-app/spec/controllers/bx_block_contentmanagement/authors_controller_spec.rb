require 'rails_helper'

RSpec.describe BxBlockContentmanagement::AuthorsController, type: :controller do

  let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
  let!(:content) { FactoryBot.create(:content, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description}, tag_list: "audio")}
  let!(:author) { FactoryBot.create(:author, contents: [content])}

  let(:observed_response_json) do
    {
      "data"=>{
        "id"=> author.id.to_s,
        "type"=>"author",
        "attributes"=>{
          "id"=> author.id,
          "name"=> author.name,
          "bio"=> author.bio,
          "created_at"=> author.created_at.as_json,
          "updated_at"=> author.updated_at.as_json,
          "contents"=>{
            "data"=>[{
              "id"=> author.contents.first.id.to_s,
              "type"=>"content",
              "attributes"=>{
                "id"=> author.contents.first.id,
                "name"=> author.contents.first.name,
                "description"=> author.contents.first.description,
                "image"=>author.contents.first.image,
                "video"=>author.contents.first.video,
                "audio"=>author.contents.first.audio,
                "study_material"=>author.contents.first.study_material,
                "category"=>{
                  "id"=>author.contents.first.category.id,
                  "name"=>author.contents.first.category.name,
                  "created_at"=>author.contents.first.category.created_at.as_json,
                  "updated_at"=>author.contents.first.category.updated_at.as_json,
                  "admin_user_id"=>nil,
                  "rank"=>author.contents.first.category.rank,
                  "light_icon"=> {"url"=> author.contents.first.category.light_icon_url},
                  "light_icon_active"=> {"url"=> author.contents.first.category.light_icon_active_url},
                  "light_icon_inactive"=> {"url"=> author.contents.first.category.light_icon_inactive_url},
                  "dark_icon"=> {"url"=> author.contents.first.category.dark_icon_url},
                  "dark_icon_active"=> {"url"=> author.contents.first.category.dark_icon_active_url},
                  "dark_icon_inactive"=> {"url"=> author.contents.first.category.dark_icon_inactive_url},
                  "identifier"=>author.contents.first.category.identifier
                },
                "sub_category"=>{
                  "id"=> author.contents.first.sub_category.id,
                  "name"=> author.contents.first.sub_category.name,
                  "created_at"=> author.contents.first.sub_category.created_at.as_json,
                  "updated_at"=> author.contents.first.sub_category.created_at.as_json,
                  "parent_id"=>nil,
                  "rank"=> author.contents.first.sub_category.rank
                },
                "language"=>{
                  "id"=> author.contents.first.language.id,
                  "name"=> author.contents.first.language.name,
                  "language_code"=> author.contents.first.language.language_code,
                  "created_at"=> author.contents.first.language.created_at.as_json,
                  "updated_at"=> author.contents.first.language.updated_at.as_json,
                  "is_content_language"=>nil, 
                  "is_app_language"=>nil
                },
                "content_type"=> {
                  "id"=> author.contents.first.content_type.id,
                  "name"=> author.contents.first.content_type.name,
                  "type"=> author.contents.first.content_type.type,
                  "created_at"=> author.contents.first.content_type.created_at.as_json,
                  "updated_at"=>author.contents.first.content_type.updated_at.as_json,
                  "identifier"=>nil,
                  "rank"=>author.contents.first.content_type.rank
                },
                "contentable"=>{
                  "data"=>{
                    "id"=> author.contents.first.contentable.id.to_s,
                    "type"=>"audio_podcast",
                    "attributes"=>{
                      "id"=> author.contents.first.contentable.id,
                      "heading"=> author.contents.first.contentable.heading,
                      "description"=> author.contents.first.contentable.description,
                      "category"=>{
                        "id"=>author.contents.first.category.id,
                        "name"=>author.contents.first.category.name,
                        "created_at"=>author.contents.first.category.created_at.as_json,
                        "updated_at"=>author.contents.first.category.updated_at.as_json,
                        "admin_user_id"=>nil,
                        "rank"=>author.contents.first.category.rank,
                        "light_icon"=> {"url"=> author.contents.first.category.light_icon_url},
                        "light_icon_active"=> {"url"=> author.contents.first.category.light_icon_active_url},
                        "light_icon_inactive"=> {"url"=> author.contents.first.category.light_icon_inactive_url},
                        "dark_icon"=> {"url"=> author.contents.first.category.dark_icon_url},
                        "dark_icon_active"=> {"url"=> author.contents.first.category.dark_icon_active_url},
                        "dark_icon_inactive"=> {"url"=> author.contents.first.category.dark_icon_inactive_url},
                        "identifier"=>author.contents.first.category.identifier
                      },
                      "sub_category"=>
                      {
                        "id"=>author.contents.first.sub_category.id,
                        "name"=>author.contents.first.sub_category.name,
                        "created_at"=>author.contents.first.sub_category.created_at.as_json,
                        "updated_at"=>author.contents.first.sub_category.updated_at.as_json,
                        "parent_id"=>nil,
                        "rank"=>author.contents.first.sub_category.rank
                      },
                      "follow"=>nil,
                      "tag_list"=> author.contents.first.tag_list,
                      "is_popular"=>author.contents.first.is_popular,
                      "is_trending"=>author.contents.first.is_trending,
                      "image"=> nil,
                      "audio"=> nil,
                      "created_at"=> author.contents.first.contentable.created_at.as_json,
                      "updated_at"=> author.contents.first.contentable.updated_at.as_json
                    }
                  }
                },
                "feature_article"=> author.contents.first.feature_article,
                "feature_video"=> author.contents.first.feature_video,
                "tag_list"=>["audio"],
                "status"=>'publish',
                "is_popular"=>author.contents.first.is_popular,
                "is_trending"=>author.contents.first.is_trending,
                "publish_date"=> author.contents.first.publish_date.as_json,
                "view_count"=> author.contents.first.view_count,
                "created_at"=> author.contents.first.created_at.as_json,
                "updated_at"=> author.contents.first.updated_at.as_json,
                "bookmark" => nil,
                "follow" => nil,
                "content_provider"=> nil
                }
              }]
            },
            "image"=>nil
          }
        }
    }
  end

  describe 'show' do
    it 'request should have status code 200' do
      get :show, params: {id: author.id}
      expect(response).to have_http_status(200)
    end

    it 'should return expected response' do
      get :show, params: {id: author.id}
      response_json = JSON.parse(response.body)
      expect(response_json).to eq (observed_response_json)
    end

    it 'should return nil' do
      get :show, params: {id: 100000}
      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to eq(nil)
    end
  end
end
