# == Schema Information
#
# Table name: bookmarks
#
#  id                :bigint           not null, primary key
#  bookmarkable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  bookmarkable_id   :bigint
#
# Indexes
#
#  index_bookmarks_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Bookmark, type: :model do
  
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
  end

  describe 'validations' do
    context "check account and content uniqueness validation" do
      let!(:account) { FactoryBot.create(:account) }
      let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
      let!(:content) { FactoryBot.create(:content, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description}, tag_list: "audio")}
      let!(:bookmark) { FactoryBot.create(:bookmark, account: account, bookmarkable: content) }
      let!(:bookmark1) { FactoryBot.build(:bookmark, account: account, bookmarkable: content) }

      it 'should not save the object and assign proper error' do
        expect(bookmark1.save).to eq(false)
        expect(bookmark1.errors["account_id"]).to eq(["content with this account is already taken"])
      end
    end  
  end
end
