# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe BxBlockAdmin::AdminUser, type: :model do
  VALID_EMAILS = ['admin@careerhunt.com', 'l1@careerhunt.com', 'l2@gmail.co', 'partner@yahoo.co.in', Faker::Internet.email, Faker::Internet.email]
  INVALID_EMAILS = ['admin@careerhunt', 'l1careerhunt.com', '@gmail.co', 'partner']

  describe 'associations' do
    it { should have_one(:admin_user_role).class_name('BxBlockAdmin::AdminUserRole').dependent(:destroy) }
    it { should have_one(:role).through(:admin_user_role).class_name('BxBlockRolesPermissions::Role')}
    it { should have_one(:partner).class_name('BxBlockRolesPermissions::Partner')}
    it { should accept_nested_attributes_for :partner }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }

    context 'should validate email format' do
      let(:role){FactoryBot.create(:role, name:"super_admin")}
      let(:user){ FactoryBot.build(:admin_user, role:role) }

      VALID_EMAILS.each do |email|
        it "should validate true for valid email: #{email}" do
          user.email = email
          expect(user.valid?).to eq(true)
        end
      end

      INVALID_EMAILS.each do |email|
        it "should validate false and add correct error for invalid email: #{email}" do
          user.email = email
          expect(user.valid?).to eq(false)
          expect(user.errors[:email]).to eq(["is invalid"])
        end
      end
    end

    context "if partner" do
      before { allow(subject).to receive(:partner?).and_return(true) }
      it { should validate_presence_of(:partner) }
    end

    context "if it is not partner" do
      before { allow(subject).to receive(:partner?).and_return(false) }
      it { should_not validate_presence_of(:partner) }
    end
  end
end
