# == Schema Information
#
# Table name: follows
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#  content_provider_id :bigint
#
# Indexes
#
#  index_follows_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Follow, type: :model do
  
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:content_provider).class_name('BxBlockAdmin::AdminUser') }
  end

  describe 'validations' do
    context "check account and content uniqueness validation" do
      let!(:account) { FactoryBot.create(:account) }
      let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
      let(:role){FactoryBot.create(:role, name:"partner")}
      let(:partner){ FactoryBot.build(:partner) }
      let!(:content_provider){ FactoryBot.create(:admin_user, email:"partner@careerhunt.com", role:role, partner: partner) }
      let!(:follow) { FactoryBot.create(:follow, account: account, content_provider_id: content_provider.id) }
      let!(:follow1) { FactoryBot.build(:follow, account: account, content_provider_id: content_provider.id) }

      it 'should not save the object and assign proper error' do
        expect(follow1.save).to eq(false)
        expect(follow1.errors["account_id"]).to eq(["content provider with this account is already taken"])
      end
    end  
  end
end
