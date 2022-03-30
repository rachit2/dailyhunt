require 'rails_helper'

RSpec.describe BxBlockAdmin::CreateAdmin, type: :services do
  let(:email) { 'admin@careerhunt.com' }

  before(:each) do
    BxBlockContentmanagement::BuildRole.call
  end

  context 'Seed admin user' do
    it 'should create super admin user with correct role and email' do
      expect(BxBlockAdmin::AdminUser.count).to eq(0)

      expect{
        BxBlockAdmin::CreateAdmin.call
      }.to change{ BxBlockAdmin::AdminUser.count }.by(1)

      admin = BxBlockAdmin::AdminUser.find_by_email(email)
      expect(admin).to be_present
      expect(admin.super_admin?).to eq(true)
    end
  end
end
