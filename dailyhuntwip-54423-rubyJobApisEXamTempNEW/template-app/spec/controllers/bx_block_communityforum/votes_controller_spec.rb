require 'rails_helper'

RSpec.describe BxBlockCommunityforum::VotesController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }
  let!(:question) { FactoryBot.create(:question, account_id: account.id)}

  let(:attrs) do
    {
      "question_id" => question.id,
      "account_id" => account.id
    }
  end

  describe 'create Vote' do
    context 'create' do
      it 'should have status 201' do
        request.headers.merge! ({"token" => auth_token})
        post :create, params: {vote: attrs}
        expect(response.status).to eq 201
      end
    
      it "likeable must exist" do
        request.headers.merge! ({"token" => auth_token})
        attrs["question_id"] = nil
        post :create, params: {like: attrs}
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Question not found")
      end
    end
  end
end
