# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint
#  commentable_id   :bigint
#
# Indexes
#
#  index_comments_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe BxBlockCommunityforum::Comment, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:commentable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }
  end

  describe 'TYPE_MAPPINGS' do
    EXPECTEDCOMMENTTYPEMAPPINGS = {
      "question" => BxBlockCommunityforum::Question.name,
      "answer" => BxBlockCommunityforum::Answer.name,
      "comment" => BxBlockCommunityforum::Comment.name
    }.freeze

    context 'valid type mappings' do
      it "valid type mappings" do
        expect(BxBlockCommunityforum::Comment::TYPE_MAPPINGS).to eq(EXPECTEDCOMMENTTYPEMAPPINGS)
      end
    end
  end
end
