# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  is_like       :boolean
#  likeable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint
#  likeable_id   :bigint
#
# Indexes
#
#  index_likes_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe BxBlockCommunityforum::Like, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:likeable) }
  end

  describe 'TYPE_MAPPINGS' do
    EXPECTEDLIKETYPEMAPPINGS = {
      "question" => BxBlockCommunityforum::Question.name,
      "answer" => BxBlockCommunityforum::Answer.name,
      "comment" => BxBlockCommunityforum::Comment.name
    }.freeze

    context 'valid type mappings' do
      it "valid type mappings" do
        expect(BxBlockCommunityforum::Comment::TYPE_MAPPINGS).to eq(EXPECTEDLIKETYPEMAPPINGS)
      end
    end
  end
end
