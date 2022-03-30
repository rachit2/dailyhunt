require 'rails_helper'

RSpec.describe BxBlockCategories::CtaController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:cta) { FactoryBot.create(:cta)}
  let!(:cta1) { FactoryBot.create(:cta, visible_on_details_page: false)}


  let(:observed_response_json) do
    {
      "data"=> [ 
        {
          "id"=> cta.id.to_s,
          "type"=> "cta",
          "attributes"=> {
              "id"=> cta.id,
              "headline"=> cta.headline,
              "description"=> cta.description,
              "category"=> {
                "id"=> cta.category.id,
                "name"=> cta.category.name,
                "identifier"=> cta.category.identifier,
                "created_at"=> cta.category.created_at.as_json,
                "updated_at"=> cta.category.updated_at.as_json,
                "admin_user_id"=>nil,
                "rank"=> cta.category.rank,
                "light_icon"=> {"url"=> cta.category.light_icon_url},
                "light_icon_active"=> {"url"=> cta.category.light_icon_active_url},
                "light_icon_inactive"=> {"url"=> cta.category.light_icon_inactive_url},
                "dark_icon"=> {"url"=> cta.category.dark_icon_url},
                "dark_icon_active"=> {"url"=> cta.category.dark_icon_active_url},
                "dark_icon_inactive"=> {"url"=> cta.category.dark_icon_inactive_url}
              },
              "is_square_cta"=> cta.is_square_cta,
              "is_long_rectangle_cta"=> cta.is_long_rectangle_cta,
              "is_text_cta"=> cta.is_text_cta,
              "is_image_cta"=> cta.is_image_cta,
              "has_button"=> cta.has_button,
              "button_text"=> cta.button_text,
              "redirect_url"=> cta.redirect_url,
              "visible_on_details_page" => cta.visible_on_details_page,
              "visible_on_home_page"=> cta.visible_on_home_page,
              "text_alignment"=> cta.text_alignment,
              "button_alignment"=> cta.button_alignment,
              "long_background_image"=> cta.long_background_image_url,
              "square_background_image"=> cta.square_background_image_url,
              "created_at"=> cta.created_at.as_json,
              "updated_at"=> cta.updated_at.as_json
          }
        }
      ]
    }
  end


  describe 'index' do

    it 'request should have status code 200' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      expect(response).to have_http_status(200)
    end

    it 'request should return correct no. of exams' do
      request.headers.merge! ({"token" => auth_token})
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq (2)
    end

    it 'request should have same exam data' do
      request.headers.merge! ({"token" => auth_token})
      get :index, params: {visible_on_details_page: true }
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(observed_response_json)
    end
  end
end
