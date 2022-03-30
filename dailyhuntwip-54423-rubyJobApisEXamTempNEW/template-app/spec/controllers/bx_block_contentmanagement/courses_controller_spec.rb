require 'rails_helper'

RSpec.describe BxBlockContentmanagement::CoursesController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:role){FactoryBot.create(:role, name:"partner")}
  let(:partner){ FactoryBot.build(:partner) }
  let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(content_provider.id) }
  let!(:course) { FactoryBot.create(:course, content_provider: content_provider) }
  let!(:lession) { FactoryBot.create(:lession, course: course) }
  let!(:lession_content) { FactoryBot.create(:lession_content, lession: lession) }
  let!(:language) { FactoryBot.create(:language) }

  let(:observed_response_json) do
    {
      "data"=>
        [
          {
            "id"=>course.id.to_s,
            "type"=>"course",
            "attributes"=>{
              "id"=>course.id,
              "category"=>{
                "id"=>course.category.id,
                "name"=>course.category.name,
                "created_at"=>course.category.created_at.as_json,
                "updated_at"=>course.category.updated_at.as_json,
                "admin_user_id"=>nil,
                "rank"=>course.category.rank,
                "light_icon"=> {"url"=> course.category.light_icon_url},
                "light_icon_active"=> {"url"=> course.category.light_icon_active_url},
                "light_icon_inactive"=> {"url"=> course.category.light_icon_inactive_url},
                "dark_icon"=> {"url"=> course.category.dark_icon_url},
                "dark_icon_active"=> {"url"=> course.category.dark_icon_active_url},
                "dark_icon_inactive"=> {"url"=> course.category.dark_icon_inactive_url},
                "identifier"=>course.category.identifier
              },
              "sub_category"=>{
                "id"=> course.sub_category.id,
                "name"=> course.sub_category.name,
                "created_at"=> course.sub_category.created_at.as_json,
                "updated_at"=> course.sub_category.created_at.as_json,
                "parent_id"=>nil,
                "rank"=> course.sub_category.rank
              },
              "heading"=>course.heading,
              "description"=>course.description,
              "what_you_will_learn_in_this_course" => course.what_you_will_learn_in_this_course,
              "enrolled_users"=>course.accounts.count,
              "user_rating"=>nil,
              "total_time"=>"#{course.lession_contents.pluck(:duration).compact.inject(0, :+)}min",
              "language"=>course.language.name,
              "price"=>course.price,
              "is_popular"=>course.is_popular,
              "is_free_trailed"=> nil,
              "is_trending"=>course.is_trending,
              "is_premium"=>course.is_premium,
              "thumbnail"=>course.thumbnail_url,
              "is_purchased"=>nil,
              "video"=>course.video_url,
              "available_free_trail"=>course.available_free_trail,
              "created_at"=>course.created_at.as_json,
              "updated_at"=>course.updated_at.as_json,
              "bookmark"=>nil,
              "course_analysis"=>nil,
              "instructors"=>{
                "data"=>[]
              },
              "content_provider"=>{
                "data"=>{
                  "id"=>content_provider.id.to_s,
                  "type"=>"content_provider",
                  "attributes"=>{
                    "id"=>content_provider.id,
                    "email"=>content_provider.email,
                    "partner_name"=>content_provider.partner_name,
                    "logo"=>nil,
                    "created_at"=>content_provider.created_at.as_json,
                    "updated_at"=>content_provider.updated_at.as_json,
                    "follow"=>nil,
                    "count"=>nil
                  }
                }
              },
              "lessions"=>{
                "data"=>[
                  {
                    "id"=>lession.id.to_s,
                    "type"=>"lession",
                    "attributes"=>{
                      "id"=>lession.id,
                      "heading"=>lession.heading,
                      "description"=>lession.description,
                      "rank"=>1,
                      "lession_contents"=>{
                        "data"=>[
                          {
                            "id"=>lession_content.id.to_s,
                            "type"=> "lession_content",
                            "attributes"=>
                            {
                              "id"=>lession_content.id,
                              "heading"=>lession_content.heading,
                              "description"=>lession_content.description,
                              "rank"=>lession_content.rank,
                              "is_free"=>false,
                              "is_purchased"=>nil,
                              "content_type"=>lession_content.content_type,
                              "duration"=>lession_content.duration,
                              "thumbnail"=>lession_content.thumbnail_url,
                              "video"=>nil,
                              "file_content"=>nil,
                              "created_at"=>lession_content.created_at.as_json,
                              "updated_at"=>lession_content.updated_at.as_json,
                              "is_lession_content_read"=>nil
                            },
                          }
                        ]
                      },
                      "created_at"=>lession.created_at.as_json,
                      "updated_at"=>lession.updated_at.as_json
                    }
                  }
                ]
              },
              "ratings"=>{
                "data"=>[]
              },
              "free_trail_remaining_days"=>nil,
              "free_trail_end_date"=>nil
            }
          }
        ],
      "total_pages"=>1
    }
  end

  describe 'index', search: true do
    it 'request should have status code 200' do
      get :index
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of courses' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (1)
    end

    it 'request should have same course data' do
      get :index
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end

    context 'filters' do
      it 'request should have status code 200 with category filter' do
        get :index, params: { category: [course.category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
      end

      it 'request should have status code 200 with sub_category filter' do
        get :index, params: { sub_category: [course.sub_category_id] }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eq (1)
      end
    end
  end

  describe 'create' do
    it 'should have status 201' do
      request.headers.merge! ({"token" => auth_token})
      post :create, params: {data: {heading: 'java course', description: 'course description', thumbnail: Rack::Test::UploadedFile.new(Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png"), "mime/type") , video: Rack::Test::UploadedFile.new(Rails.root.join("#{Rails.root}/app/assets/videos/java.mp4"), "mime/type"), price: 500, content_type: 'video', language_id: language.id, category_id: course.category_id, sub_category_id: course.sub_category_id}}
      expect(response.status).to eq 200
    end

    it 'should return error content provider should partner' do
      token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
      request.headers.merge! ({"token" => token})
      post :create, params: {data: {heading: 'java course', description: 'course description', thumbnail: Rack::Test::UploadedFile.new(Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png"), "mime/type") , video: Rack::Test::UploadedFile.new(Rails.root.join("#{Rails.root}/app/assets/videos/java.mp4"), "mime/type"), price: 500, content_type: 'video', language_id: language.id}}
      json_response = JSON.parse(response.body)
      expect(response.status).to eq 404
      expect(json_response["error"]).to eq("please login with partner")
    end
  end


end
